########################################################################################################################
# Outputs
########################################################################################################################

output "ibm_mq_operator_deployment_namespace" {
  description = "Namespace where the IBM MQ operator is installed."
  value       = module.ibm_mq_operator.ibm_mq_operator_namespace
}

output "ibm_mq_operator_deployment_target_namespace" {
  description = "Namespace watched by the IBM MQ operator."
  value       = module.ibm_mq_operator.ibm_mq_operator_target_namespace
}
