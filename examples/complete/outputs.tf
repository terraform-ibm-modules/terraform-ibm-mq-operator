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
