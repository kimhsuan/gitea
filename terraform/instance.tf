module "instance" {
  source = "./modules/gitea_instance"

  project_id   = var.project_id
  name         = "${var.org_name}-${var.app_name}-${var.environment}"
  region       = var.region
  machine_type = "e2-micro"
  ssh_keys     = var.ssh_keys
  tags = [
    "allow-cloud-iap",
  ]

  boot_disk = {
    image   = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
    size_gb = 10
    type    = "pd-standard"
  }

  attached_disks = [
    {
      name       = "data"
      type       = "pd-standard"
      size_gb    = 10
      mount_path = "/data"
    },
  ]

  network_interface = [
    {
      network    = module.vpc.network_name
      subnetwork = module.vpc.subnets["${var.region}/${var.org_name}-${var.app_name}-${var.environment}-vpc-1-subnet-1"].name
      access_config = [
        {
          network_tier = "STANDARD"
        },
      ]
    },
  ]

  deletion_protection = var.environment == "prod" ? true : false
}
