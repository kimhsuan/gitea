module "workload_identity_federation_github" {
  count  = var.environment == "prod" ? 1 : 0
  source = "./modules/workload_identity_federation"

  project_id        = var.project_id
  org_name          = var.org_name
  pool_id           = "github"
  pool_display_name = "GitHub Actions Pool"
  pool_provider_list = [
    {
      provider_id         = "my-repo"
      display_name        = "My GitHub repo Provider"
      attribute_condition = <<-EOT
        assertion.repository_owner == '${var.github_repository_owner}' &&
        attribute.repository == '${var.github_repository}'
      EOT
      attribute_map = {
        "google.subject"             = "assertion.sub"
        "attribute.actor"            = "assertion.actor"
        "attribute.repository"       = "assertion.repository"
        "attribute.repository_owner" = "assertion.repository_owner"
      }
      oidc_issuer_uri = "https://token.actions.githubusercontent.com"
    }
  ]
  iam_members = [
    "roles/iap.tunnelResourceAccessor",
    "roles/compute.instanceAdmin.v1",
    "roles/iam.serviceAccountUser",
  ]
}

# import {
#   id = "projects/kim-test-net/locations/global/workloadIdentityPools/github"
#   to = module.workload_identity_federation_github[0].google_iam_workload_identity_pool.main
# }

# import {
#   id = "projects/kim-test-net/locations/global/workloadIdentityPools/github/providers/my-repo"
#   to = module.workload_identity_federation_github[0].google_iam_workload_identity_pool_provider.main["my-repo"]
# }
