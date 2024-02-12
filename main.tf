locals {
  # sleep times definition
  sleep_time_operator_create = "120s"

  # helm chart names
  ibm_mq_operator_chart       = "ibm-mq-operator"
  ibm_mq_operator_group_chart = "ibm-mq-operator-group"

  # validation of ws_mq_operator_target_namespace - if null the value of ws_mq_operator_namespace must be equal to "openshift-operators" https://www.ibm.com/docs/en/ibm-mq/9.3?topic=imo-installing-mq-operator-using-red-hat-openshift-cli
  default_ibm_mq_operator_namespace = "openshift-operators"
  operator_target_namespace_cnd     = var.ibm_mq_operator_target_namespace == null && var.ibm_mq_operator_namespace != local.default_ibm_mq_operator_namespace
  operator_target_namespace_msg     = "if input var ibm_mq_operator_target_namespace is null the value of ibm_mq_operator_namespace must be equal to ${local.default_ibm_mq_operator_namespace}"
  # tflint-ignore: terraform_unused_declarations
  operator_target_namespace_chk = regex("^${local.operator_target_namespace_msg}$", (!local.operator_target_namespace_cnd ? local.operator_target_namespace_msg : ""))
}

data "ibm_container_cluster_config" "cluster_config" {
  cluster_name_id = var.cluster_id
  config_dir      = "${path.module}/kubeconfig"
  endpoint_type   = var.cluster_config_endpoint_type != "default" ? var.cluster_config_endpoint_type : null
}

# creating the namespace to deploy the helm releases to install the IBM MQ Operator
resource "kubernetes_namespace" "helm_release_operator_namespace" {
  metadata {
    name = var.operator_helm_release_namespace
  }

  timeouts {
    delete = "30m"
  }

  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels
    ]
  }
}

# if ws_mq_operator_target_namespace != null the operator group must be created
resource "helm_release" "ibm_mq_operator_group" {
  count      = var.ibm_mq_operator_target_namespace != null ? 1 : 0
  depends_on = [kubernetes_namespace.helm_release_operator_namespace]

  name             = "ibm-mq-operator-group-helm-release"
  chart            = "${path.module}/chart/${local.ibm_mq_operator_group_chart}"
  namespace        = var.operator_helm_release_namespace
  create_namespace = false
  timeout          = 300
  # dependency_update = true
  force_update = true
  # force_update      = false
  cleanup_on_fail = false
  wait            = true
  recreate_pods   = true

  disable_openapi_validation = false

  set {
    name  = "operatornamespace"
    type  = "string"
    value = var.ibm_mq_operator_namespace
  }

  set {
    name  = "operatortargetnamespace"
    type  = "string"
    value = var.ibm_mq_operator_target_namespace
  }

}

resource "kubernetes_namespace" "ibm_mq_operator_namespace" {
  count = var.create_ibm_mq_operator_namespace == true ? 1 : 0

  metadata {
    name = var.ibm_mq_operator_namespace
  }

  timeouts {
    delete = "30m"
  }

  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels
    ]
  }
}

resource "helm_release" "ibm_mq_operator" {
  depends_on = [helm_release.ibm_mq_operator_group[0], kubernetes_namespace.ibm_mq_operator_namespace[0]]

  name             = "ibm-mq-operator-helm-release"
  chart            = "${path.module}/chart/${local.ibm_mq_operator_chart}"
  namespace        = var.operator_helm_release_namespace
  create_namespace = false
  timeout          = 300
  # dependency_update = true
  # force_update      = false
  force_update    = true
  cleanup_on_fail = false
  wait            = true
  recreate_pods   = true

  disable_openapi_validation = false

  set {
    name  = "operatornamespace"
    type  = "string"
    value = var.ibm_mq_operator_namespace
  }

  provisioner "local-exec" {
    command     = "${path.module}/scripts/approve-install-plan.sh ${var.ibm_mq_operator_namespace}"
    interpreter = ["/bin/bash", "-c"]
    environment = {
      KUBECONFIG = data.ibm_container_cluster_config.cluster_config.config_file_path
    }
  }
}

resource "time_sleep" "wait_ibm_mq_operator" {
  depends_on = [helm_release.ibm_mq_operator]

  create_duration = local.sleep_time_operator_create
}

##############################################################################
# Confirm websphere operator is operational
##############################################################################

resource "null_resource" "confirm_ibm_mq_operator_operational" {

  depends_on = [time_sleep.wait_ibm_mq_operator]

  provisioner "local-exec" {
    command     = "${path.module}/scripts/confirm-ibm-mq-operator-operational.sh ${var.ibm_mq_operator_namespace}"
    interpreter = ["/bin/bash", "-c"]
    environment = {
      KUBECONFIG = data.ibm_container_cluster_config.cluster_config.config_file_path
    }
  }
}
