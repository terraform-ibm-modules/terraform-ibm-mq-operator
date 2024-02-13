##############################################################################
# Input Variables
##############################################################################

variable "ibmcloud_api_key" {
  description = "APIkey that's associated with the account to use"
  type        = string
  sensitive   = true
  default     = null
}

variable "region" {
  description = "Cluster region"
  type        = string
  nullable    = false
}

variable "cluster_id" {
  type        = string
  description = "Id of the target IBM Cloud OpenShift Cluster"
  nullable    = false
}

variable "operator_helm_release_namespace" {
  type        = string
  description = "Namespace to deploy the helm releases. Default to ibm-mq-operator helm release"
  default     = "ibm-mq-operator"
  nullable    = false
}

variable "add_ibm_operator_catalog" {
  type        = bool
  description = "Flag to configure the IBM Operator Catalog in the cluster before installing the IBM MQ Operator. Default is true"
  default     = true
}

variable "create_ibm_mq_operator_namespace" {
  type        = bool
  description = "Flag to create the namespace where to deploy the IBM MQ Operator. Default to false"
  default     = false
}

variable "ibm_mq_operator_namespace" {
  type        = string
  description = "Namespace to install the IBM MQ Operator. Default to openshift-operators"
  default     = "openshift-operators"
  nullable    = false
}

variable "ibm_mq_operator_target_namespace" {
  type        = string
  description = "Namespace to be watched by the IBM MQ Operator. Default to null (operator to watch all namespaces)"
  default     = null
}

variable "cluster_config_endpoint_type" {
  description = "Specify which type of endpoint to use for for cluster config access: 'default', 'private', 'vpe', 'link'. 'default' value will use the default endpoint of the cluster."
  type        = string
  default     = "default"
  nullable    = false # use default if null is passed in
  validation {
    error_message = "Invalid Endpoint Type! Valid values are 'default', 'private', 'vpe', or 'link'"
    condition     = contains(["default", "private", "vpe", "link"], var.cluster_config_endpoint_type)
  }
}
