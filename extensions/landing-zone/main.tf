##############################################################################
# IBM WebSphere Liberty operator deployment on the OCP cluster
##############################################################################

data "ibm_container_cluster_config" "cluster_config" {
  cluster_name_id = var.cluster_id
  config_dir      = "${path.module}/kubeconfig"
  endpoint_type   = var.cluster_config_endpoint_type != "default" ? var.cluster_config_endpoint_type : null # null represents default
}

module "ibm_mq_operator" {
  source                           = "../.."
  cluster_id                       = var.cluster_id
  add_ibm_operator_catalog         = var.add_ibm_operator_catalog
  create_ibm_mq_operator_namespace = var.create_ibm_mq_operator_namespace
  ibm_mq_operator_namespace        = var.ibm_mq_operator_namespace
  ibm_mq_operator_target_namespace = var.ibm_mq_operator_target_namespace
  cluster_config_endpoint_type     = var.cluster_config_endpoint_type
  operator_helm_release_namespace  = var.operator_helm_release_namespace
}
