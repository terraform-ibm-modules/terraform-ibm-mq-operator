########################################################################################################################
# Outputs
########################################################################################################################

output "ibm_mq_operator_namespace" {
  description = "Namespace where the IBM MQ operator is installed"
  value       = var.ibm_mq_operator_namespace
}

output "ibm_mq_operator_target_namespace" {
  description = "Namespace watched by the IBM MQ operator"
  value       = var.ibm_mq_operator_target_namespace
}
