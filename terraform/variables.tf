variable "project_id" {
  description = "The project ID for the Google Cloud resources."
  type        = string
}

variable "org_name" {
  type = string
}

variable "app_name" {
  type    = string
  default = "gitea"
}

variable "environment" {
  type    = string
  default = "test"
}

variable "region" {
  description = "The region where the resources will be deployed."
  type        = string
  default     = "us-west1"
}

variable "github_repository_owner" {
  type = string
}

variable "github_repository" {
  type = string
}

variable "ssh_keys" {
  description = "SSH keys to apply to the instance."
  type        = string
  default     = ""
}
