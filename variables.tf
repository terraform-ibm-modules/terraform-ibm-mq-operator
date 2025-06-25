##############################################################################
# Input Variables
##############################################################################

variable "cluster_id" {
  type        = string
  description = "ID of the target cluster where the IBM MQ operator will be installed."
  nullable    = false
}

variable "operator_helm_release_namespace" {
  type        = string
  description = "Namespace where the helm releases are deployed. Default is `ibm-mq-operator`."
  default     = "ibm-mq-operator"
  nullable    = false
}

variable "add_ibm_operator_catalog" {
  type        = bool
  description = "Install the IBM Operator Catalog in the cluster before installing the IBM MQ Operator. Default is `true`."
  default     = true
}

variable "create_queue_manager" {
  type        = bool
  description = "Set to true to create a Queue Manager for the IBM MQ operator. Default is `true`."
  default     = true
}

variable "queue_manager_name" {
  type        = string
  description = "Name of the IBM MQ Queue Manager."
  default     = null

  validation {
    condition     = !var.create_queue_manager || var.queue_manager_name != null
    error_message = "If create_queue_manager is true, then queue_manager_name must not be null."
  }
}

variable "create_ibm_mq_queue_manager_namespace" {
  type        = bool
  description = "Set to true to create the namespace where the IBM MQ Queue Manager will be installed. Default to `true`."
  default     = true

  validation {
    condition     = !var.create_ibm_mq_queue_manager_namespace || var.create_queue_manager
    error_message = "If create_ibm_mq_queue_manager_namespace is true, then create_queue_manager must also be true."
  }
}

variable "ibm_mq_queue_manager_namespace" {
  type        = string
  description = "Namespace where the IBM MQ Queue Manager will be installed. Its only used when `var.create_ibm_mq_queue_manager_namespace` is set to true."
  default     = null

  validation {
    condition     = !var.create_ibm_mq_queue_manager_namespace || var.ibm_mq_queue_manager_namespace != null
    error_message = "If create_ibm_mq_queue_manager_namespace is true, then ibm_mq_queue_manager_namespace must not be null."
  }
}

variable "queue_manager_license" {
  type        = string
  description = "IBM MQ Queue Manager license. More info on IBM MQ Queue Manager licenses and its usage can be seen here: https://www.ibm.com/docs/en/ibm-mq/9.3?topic=mqibmcomv1beta1-licensing-reference."
  default     = null

  validation {
    condition     = !var.create_queue_manager || var.queue_manager_license != null
    error_message = "If create_queue_manager is true, then queue_manager_license must not be null."
  }
}

variable "queue_manager_license_usage" {
  type        = string
  description = "IBM MQ Queue Manager license usage. More info on IBM MQ Queue Manager licenses and its usage can be seen here: https://www.ibm.com/docs/en/ibm-mq/9.3?topic=mqibmcomv1beta1-licensing-reference."
  default     = null

  validation {
    condition     = !var.create_queue_manager || var.queue_manager_license_usage != null
    error_message = "If create_queue_manager is true, then queue_manager_license_usage must not be null."
  }
}

variable "queue_manager_version" {
  type        = string
  description = "IBM MQ Queue Manager version. Make sure the version is compatible with the IBM MQ Queue Manager license and usage."
  default     = "9.3.3.3-r1"

  validation {
    condition     = !var.create_queue_manager || var.queue_manager_version != null
    error_message = "If create_queue_manager is true, then queue_manager_version must not be null."
  }
}

variable "create_ibm_mq_operator_namespace" {
  type        = bool
  description = "Set to true to create the namespace where the IBM MQ Operator will be deployed. Default to `false`."
  default     = false
}

variable "ibm_mq_operator_namespace" {
  type        = string
  description = "Namespace where the IBM MQ operator is deployed. Default is `openshift-operators`."
  default     = "openshift-operators"
  nullable    = false

  validation {
    condition = (
      var.ibm_mq_operator_target_namespace != null ||
      var.ibm_mq_operator_namespace == "openshift-operators"
    )
    error_message = "If ibm_mq_operator_target_namespace is null, then ibm_mq_operator_namespace must be equal to 'openshift-operators'."
  }
}

variable "ibm_mq_operator_target_namespace" {
  type        = string
  description = "Namespace to be watched by the IBM MQ Operator. Default is `null`, which means that the operator watches all the namespaces."
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
