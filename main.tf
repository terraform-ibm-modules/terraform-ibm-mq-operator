locals {
  # sleep times definition
  sleep_time_catalog_create  = "60s"
  sleep_time_operator_create = "120s"

  # helm chart names
  ibm_operator_catalog_chart  = "ibm-operator-catalog"
  ibm_mq_operator_chart       = "mq-operator"
  ibm_mq_operator_group_chart = "mq-operator-group"

  # validation of ibm_mq_operator_target_namespace - if null the value of ibm_mq_operator_namespace must be equal to "openshift-operators" https://www.ibm.com/docs/en/ibm-mq/9.3?topic=imo-installing-mq-operator-using-red-hat-openshift-cli
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

locals {
  ibm_operator_catalog_version = "v1.25-20240202.161709-9DAF3E648@sha256:92e28be4af60f68c656f52b2445aafcc052fcd0390479b868c5b0ba2d465a25a" # datasource: icr.io/cpopen/ibm-operator-catalog
  ibm_operator_catalog_path    = "icr.io/cpopen/ibm-operator-catalog"
}

# if add_ibm_operator_catalog is true going on with adding the IBM Operator Catalog source
resource "helm_release" "ibm_operator_catalog" {
  depends_on       = [kubernetes_namespace.helm_release_operator_namespace]
  count            = var.add_ibm_operator_catalog == true ? 1 : 0
  name             = "ibm-operator-catalog-helm-release"
  chart            = "${path.module}/chart/${local.ibm_operator_catalog_chart}"
  namespace        = var.operator_helm_release_namespace
  create_namespace = false
  timeout          = 300
  force_update     = true
  cleanup_on_fail  = false
  wait             = true
  recreate_pods    = true

  disable_openapi_validation = false

  set {
    name  = "image.path"
    type  = "string"
    value = local.ibm_operator_catalog_path
  }
  set {
    name  = "image.version"
    type  = "string"
    value = local.ibm_operator_catalog_version
  }
}

# waiting for the catalog to be configured and correctly pulled
resource "time_sleep" "wait_catalog" {
  depends_on = [helm_release.ibm_operator_catalog[0]]
  count      = var.add_ibm_operator_catalog == true ? 1 : 0

  create_duration = local.sleep_time_catalog_create
}

# if ws_mq_operator_target_namespace != null the operator group must be created
resource "helm_release" "ibm_mq_operator_group" {
  count      = var.ibm_mq_operator_target_namespace != null ? 1 : 0
  depends_on = [time_sleep.wait_catalog[0], kubernetes_namespace.helm_release_operator_namespace]

  name             = "ibm-mq-operator-group-helm-release"
  chart            = "${path.module}/chart/${local.ibm_mq_operator_group_chart}"
  namespace        = var.operator_helm_release_namespace
  create_namespace = false
  timeout          = 300
  force_update     = true
  cleanup_on_fail  = false
  wait             = true
  recreate_pods    = true

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
  depends_on = [time_sleep.wait_catalog[0], helm_release.ibm_mq_operator_group[0], kubernetes_namespace.ibm_mq_operator_namespace[0]]

  name             = "ibm-mq-operator-helm-release"
  chart            = "${path.module}/chart/${local.ibm_mq_operator_chart}"
  namespace        = var.operator_helm_release_namespace
  create_namespace = false
  timeout          = 300
  force_update     = true
  cleanup_on_fail  = false
  wait             = true
  recreate_pods    = true

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
