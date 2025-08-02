variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "name" {
  description = "The name of the instance"
  type        = string
}

variable "machine_type" {
  description = "The machine type to create. If not specified, defaults to 'e2-micro'."
  type        = string
  default     = "e2-micro"
}

variable "region" {
  description = "The region to create the instance in"
  type        = string
  default     = null
}

variable "zone" {
  description = "The zone to create the instance in"
  type        = string
  default     = null
}

variable "tags" {
  description = "A list of network tags to apply to the instance."
  type        = list(string)
  default     = []
}

variable "labels" {
  description = "A map of labels to apply to the instance."
  type        = map(string)
  default     = {}
}

variable "metadata" {
  description = "A map of metadata to apply to the instance."
  type        = map(string)
  default     = {}
}

variable "ssh_keys" {
  description = "SSH keys to apply to the instance."
  type        = string
  default     = ""
}

variable "block_project_ssh_keys" {
  description = "Whether to block project-wide SSH keys."
  type        = bool
  default     = true
}

variable "boot_disk" {
  description = "The boot disk configuration."
  type = object({
    auto_delete = optional(bool, false)
    device_name = optional(string)
    size_gb     = optional(number, 10)
    type        = optional(string, "pd-standard")
    image       = optional(string, "ubuntu-os-cloud/ubuntu-2404-lts-amd64")
    snapshot    = optional(string)
  })
}

variable "attached_disks" {
  description = "List of attached disks."
  type = list(object({
    name       = string
    type       = optional(string, "pd-standard")
    size_gb    = optional(number, 10)
    mount_path = string
    snapshot   = optional(string)
  }))
  default = []
}

variable "disk_kms_key_self_link" {
  description = "The self-link of the KMS key to use for disk encryption."
  type        = string
  default     = null
}

variable "network_interface" {
  description = "The network interface configuration."
  type = list(object({
    network            = optional(string)
    subnetwork         = optional(string)
    subnetwork_project = optional(string)
    network_ip         = optional(string)
    access_config = optional(list(object({
      nat_ip       = optional(string)
      network_tier = optional(string)
    })))
  }))
}

variable "service_account" {
  description = "The service account to attach to the instance."
  type = object({
    email  = optional(string)
    scopes = set(string)
  })
  default = null
}

variable "startup_script" {
  description = "The startup script to run on the instance."
  type        = string
  default     = null
}

variable "deletion_protection" {
  description = "Whether or not to prevent the instance from being accidentally deleted."
  type        = bool
  default     = false
}

variable "can_ip_forward" {
  description = "Whether to allow this instance to send and receive packets with non-matching destination or source IPs."
  type        = bool
  default     = false
}

variable "shielded_instance_config" {
  description = "The shielded instance configuration."
  type = object({
    enable_secure_boot          = optional(bool, false)
    enable_vtpm                 = optional(bool, false)
    enable_integrity_monitoring = optional(bool, false)
  })
  default = {}
}
