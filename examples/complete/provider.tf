##############################################################################
# Config providers
##############################################################################

# IBM provider used to provision IBM Cloud resources
provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
}

# Init cluster config for helm and kubernetes providers
data "ibm_container_cluster_config" "cluster_config" {
  cluster_name_id   = module.ocp_base.cluster_id
  resource_group_id = module.resource_group.resource_group_id
}

# Helm provider used to deploy cluster-proxy and observability agents
provider "helm" {
  kubernetes = {
    host  = data.ibm_container_cluster_config.cluster_config.host
    token = data.ibm_container_cluster_config.cluster_config.token
  }
}

# Kubernetes provider used to create kube namespace(s)
provider "kubernetes" {
  host  = data.ibm_container_cluster_config.cluster_config.host
  token = data.ibm_container_cluster_config.cluster_config.token
}
