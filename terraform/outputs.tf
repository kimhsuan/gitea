output "workload_identity_pool_provider_name" {
  description = "The name of the workload identity pool provider from the github module."
  value       = var.environment == "prod" ? module.workload_identity_federation_github[0].workload_identity_pool_provider_names["my-repo"] : null
}

output "workload_identity_pool_name" {
  description = "The name of the workload identity pool from the github module."
  value       = var.environment == "prod" ? module.workload_identity_federation_github[0].workload_identity_pool_name : null
}
