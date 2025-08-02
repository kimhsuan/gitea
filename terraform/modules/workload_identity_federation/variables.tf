variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "org_name" {
  type = string
}

variable "pool_id" {
  type = string
}

variable "pool_display_name" {
  type = string
}

variable "pool_provider_list" {
  type = list(object({
    provider_id         = string
    display_name        = string
    attribute_condition = string
    attribute_map       = map(string)
    oidc_issuer_uri     = optional(string)
  }))
}

variable "iam_members" {
  description = "IAM members to be added to the workload identity pool"
  type        = list(string)
  default     = []
}
