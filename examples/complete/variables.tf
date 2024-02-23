variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API key."
  sensitive   = true
}

variable "prefix" {
  type        = string
  description = "Prefix for name of all resource created by this example."
  default     = "mqop"
}

variable "region" {
  type        = string
  description = "Region to provision all resources created by this example."
  default     = "au-syd"
}

variable "ocp_version" {
  description = "The version of the OpenShift cluster that should be provisioned (format 4.x)."
  type        = string
  default     = null
}

variable "resource_group" {
  type        = string
  description = "An existing resource group name to use for this example, if unset a new resource group will be created."
  default     = null
}

variable "resource_tags" {
  type        = list(string)
  description = "Optional list of tags to be added to created resources."
  default     = []
}

variable "queue_manager_license" {
  type        = string
  description = "IBM MQ Queue Manager license. More info on IBM MQ Queue Manager licenses and its usage can be seen here: https://www.ibm.com/docs/en/ibm-mq/9.3?topic=mqibmcomv1beta1-licensing-reference."
}

variable "queue_manager_license_usage" {
  type        = string
  description = "IBM MQ Queue Manager license usage. More info on IBM MQ Queue Manager licenses and its usage can be seen here: https://www.ibm.com/docs/en/ibm-mq/9.3?topic=mqibmcomv1beta1-licensing-reference."
}
