########################################################################################################################
# Outputs
########################################################################################################################

output "resource_group_name" {
  description = "Resource group name."
  value       = module.resource_group.resource_group_name
}

output "cluster_id" {
  description = "Cluster ID."
  value       = module.ocp_base.cluster_id
}

output "url" {
  description = "Queue Manager web URL"
  value       = module.ibm_mq_operator.ibm_mq_queue_manager_web_url
}
