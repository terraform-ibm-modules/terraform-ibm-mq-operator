##############################################################################
# IBM WebSphere Liberty operator deployment on the OCP cluster
##############################################################################

data "ibm_container_cluster_config" "cluster_config" {
  cluster_name_id = var.cluster_id
  config_dir      = "${path.module}/kubeconfig"
  endpoint_type   = var.cluster_config_endpoint_type != "default" ? var.cluster_config_endpoint_type : null # null represents default
}

module "websphere_liberty_operator" {
  source                               = "../.."
  ibmcloud_api_key                     = var.ibmcloud_api_key
  region                               = var.region
  cluster_id                           = var.cluster_id
  create_ws_liberty_operator_namespace = var.create_ibm_mq_operator_namespace
  ws_liberty_operator_namespace        = var.ibm_mq_operator_namespace
  ws_liberty_operator_target_namespace = var.ibm_mq_operator_target_namespace
  cluster_config_endpoint_type         = var.cluster_config_endpoint_type
  operator_helm_release_namespace      = var.operator_helm_release_namespace
}
