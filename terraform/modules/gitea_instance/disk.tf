resource "google_compute_disk" "boot" {
  project  = var.project_id
  name     = var.name
  zone     = var.zone == null ? data.google_compute_zones.available.names[0] : var.zone
  type     = var.boot_disk.type
  size     = var.boot_disk.size_gb
  image    = var.boot_disk.image
  snapshot = var.boot_disk.snapshot
  labels   = var.labels

  dynamic "disk_encryption_key" {
    for_each = var.disk_kms_key_self_link != null ? [1] : []
    content {
      kms_key_self_link = var.disk_kms_key_self_link
    }
  }
}

resource "google_compute_disk" "attached" {
  for_each = {
    for disk in var.attached_disks : disk.name => disk
  }
  project = var.project_id
  name    = "${var.name}-${each.value.name}"
  zone    = var.zone == null ? data.google_compute_zones.available.names[0] : var.zone
  size    = each.value.size_gb
  type    = each.value.type
  labels  = var.labels

  dynamic "disk_encryption_key" {
    for_each = var.disk_kms_key_self_link != null ? [1] : []
    content {
      kms_key_self_link = var.disk_kms_key_self_link
    }
  }
}
