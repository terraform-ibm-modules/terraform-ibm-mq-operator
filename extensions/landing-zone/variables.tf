variable "ibmcloud_api_key" {
  type        = string
  description = "APIkey associated with the account to use"
  sensitive   = true
}

variable "region" {
  type        = string
  description = "Region where the target cluster is deployed."
  nullable    = false
}

variable "cluster_id" {
  type        = string
  description = "Id of the target cluster."
  nullable    = false
}

variable "operator_helm_release_namespace" {
  type        = string
  description = "Namespace to deploy the helm releases. Default to ibm-mq-operator."
  default     = "ibm-mq-operator"
}

variable "create_queue_manager" {
  type        = bool
  description = "Flag to create a Queue Manager for the IBM MQ operator. Default is true."
  default     = true
}

variable "queue_manager_name" {
  type        = string
  description = "Name of the IBM MQ Queue Manager. Default to mq-qm."
  default     = "mq-qm"
}

variable "create_ibm_mq_queue_manager_namespace" {
  type        = bool
  description = "Flag to create the namespace where to create the IBM MQ Queue Manager. Default to true."
  default     = true
}

variable "ibm_mq_queue_manager_namespace" {
  type        = string
  description = "Namespace to install the IBM MQ Queue Manager. Default to mq-qm-ns."
  default     = "mq-qm-ns"
}

variable "queue_manager_license" {
  type        = string
  description = "IBM MQ Queue Manager license. More info on IBM MQ Queue Manager licenses and its usage can be seen here: https://www.ibm.com/docs/en/ibm-mq/9.3?topic=mqibmcomv1beta1-licensing-reference."
  default     = "L-AXAF-JLZ53A"
}

variable "queue_manager_license_usage" {
  type        = string
  description = "IBM MQ Queue Manager license usage. More info on IBM MQ Queue Manager licenses and its usage can be seen here: https://www.ibm.com/docs/en/ibm-mq/9.3?topic=mqibmcomv1beta1-licensing-reference."
  default     = "Development"
}

variable "queue_manager_version" {
  type        = string
  description = "IBM MQ Queue Manager version."
  default     = "9.3.3.3-r1"
}

variable "add_ibm_operator_catalog" {
  type        = bool
  description = "Flag to configure the IBM Operator Catalog in the cluster before installing the IBM MQ Operator. Default is true."
  default     = true
}

variable "create_ibm_mq_operator_namespace" {
  type        = bool
  description = "Flag to create the namespace where to deploy the IBM MQ Operator. Default to false."
  default     = false
}

variable "ibm_mq_operator_namespace" {
  type        = string
  description = "Namespace to install the IBM MQ operator. Default to openshift-operators."
  default     = "openshift-operators"
}

variable "ibm_mq_operator_target_namespace" {
  type        = string
  description = "Namespace to be watched by the IBM MQ Operator. Default is 'null', which means that the operator watches all the namespaces."
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
