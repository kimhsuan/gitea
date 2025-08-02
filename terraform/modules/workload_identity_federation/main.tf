resource "google_iam_workload_identity_pool" "main" {
  project                   = var.project_id
  workload_identity_pool_id = var.pool_id
  display_name              = var.pool_display_name
}

resource "google_iam_workload_identity_pool_provider" "main" {
  for_each = {
    for provider in var.pool_provider_list : provider.provider_id => provider
  }
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.main.workload_identity_pool_id
  workload_identity_pool_provider_id = each.value.provider_id
  display_name                       = each.value.display_name
  attribute_condition                = each.value.attribute_condition
  attribute_mapping                  = each.value.attribute_map
  dynamic "oidc" {
    for_each = [each.value.oidc_issuer_uri]
    content {
      issuer_uri = oidc.value
    }
  }
}

resource "google_project_iam_member" "workload_identity_user" {
  project = var.project_id
  role    = "roles/iam.workloadIdentityUser"
  member  = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.main.name}/*"
}

resource "google_project_iam_member" "main" {
  for_each = toset(var.iam_members)
  project  = var.project_id
  role     = each.key
  member   = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.main.name}/*"
}
