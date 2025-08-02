output "workload_identity_pool_provider_names" {
  description = "The names of the workload identity pool providers."
  value = {
    for k, v in google_iam_workload_identity_pool_provider.main : k => v.name
  }
}

output "workload_identity_pool_name" {
  description = "The name of the workload identity pool."
  value       = google_iam_workload_identity_pool.main.name
}
