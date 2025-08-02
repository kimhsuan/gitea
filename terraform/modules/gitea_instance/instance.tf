resource "google_compute_instance" "default" {
  project      = var.project_id
  zone         = var.zone == null ? data.google_compute_zones.available.names[0] : var.zone
  name         = var.name
  machine_type = var.machine_type
  tags         = var.tags
  labels       = var.labels
  # metadata     = var.metadata
  metadata = {
    user-data = templatefile("${path.module}/assets/cloud-config.yaml.tftpl", {
      attached_disks = [for disk in var.attached_disks : {
        device_name = "${var.name}-${disk.name}"
        label       = disk.name
        mount_path  = disk.mount_path
      }]
    })
    ssh-keys               = var.ssh_keys
    block-project-ssh-keys = var.block_project_ssh_keys
  }

  boot_disk {
    auto_delete = var.boot_disk.auto_delete
    device_name = coalesce(var.boot_disk.device_name, var.name)
    mode        = "READ_WRITE"
    source      = google_compute_disk.boot.self_link
  }

  dynamic "attached_disk" {
    for_each = var.attached_disks
    content {
      source      = google_compute_disk.attached[attached_disk.value.name].self_link
      device_name = "${var.name}-${attached_disk.value.name}"
    }
  }

  dynamic "network_interface" {
    for_each = var.network_interface
    content {
      network            = lookup(network_interface.value, "network", null)
      subnetwork         = lookup(network_interface.value, "subnetwork", null)
      subnetwork_project = lookup(network_interface.value, "subnetwork_project", null)
      network_ip         = lookup(network_interface.value, "network_ip", null)

      dynamic "access_config" {
        for_each = lookup(network_interface.value, "access_config", [])
        content {
          nat_ip       = lookup(access_config.value, "nat_ip", null)
          network_tier = lookup(access_config.value, "network_tier", null)
        }
      }
    }
  }

  dynamic "service_account" {
    for_each = var.service_account != null ? [var.service_account] : []
    content {
      email  = service_account.value.email
      scopes = service_account.value.scopes
    }
  }

  metadata_startup_script = var.startup_script
  deletion_protection     = var.deletion_protection
  can_ip_forward          = var.can_ip_forward

  shielded_instance_config {
    enable_secure_boot          = var.shielded_instance_config.enable_secure_boot
    enable_vtpm                 = var.shielded_instance_config.enable_vtpm
    enable_integrity_monitoring = var.shielded_instance_config.enable_integrity_monitoring
  }
}
