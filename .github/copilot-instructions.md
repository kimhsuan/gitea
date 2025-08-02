## Copilot Instructions for the Gitea IaC Repository

### Project Overview

This repository provisions and manages a Gitea instance on Google Cloud Platform (GCP) using Terraform and Docker Compose. It is designed for modularity, security, and automation, with clear separation between infrastructure and application layers.

### Architecture

- **Terraform (`terraform/`)**: Provisions GCP resources (VM, disks, network, IAM, Workload Identity Federation). Uses modules for reusability (`modules/gitea_instance`, `modules/workload_identity_federation`).
- **Docker Compose (`compose/`)**: Defines containerized services (Gitea, Cloudflared) using a main `compose.yaml` that includes service-specific files.
- **Cloud-Init (`cloud-config.yaml.tftpl`)**: Bootstraps the VM with Docker, disk formatting, and prepares the environment for containers.

### Key Integration Points

- The VM is provisioned by Terraform and bootstrapped via a cloud-init template (`cloud-config.yaml.tftpl`), which installs Docker and configures disk mounts.
- Docker Compose files are deployed on the VM, with environment variables and secrets managed via `.env` files and GCP secrets.
- Workload Identity Federation is configured for secure GitHub Actions deployments to GCP.

### Developer Workflows

- **Terraform (run in `terraform/`):**
  - `terraform init` — Initialize modules and providers.
  - `terraform validate` — Check configuration syntax.
  - `terraform plan` — Preview infrastructure changes.
  - `terraform apply` — Provision/update resources.
- **Docker Compose (run on VM):**
  - Start: `docker-compose -f /opt/gitea/compose/compose.yaml up -d`
  - Stop: `docker-compose -f /opt/gitea/compose/compose.yaml down`
- **SSH/IAP Tunnel:** Use `gcloud compute ssh` with IAP tunneling (see `README.md`) to connect securely to the VM and access the Docker daemon.

### Project Conventions

- **Modular Terraform:** Use input variables and outputs; avoid hardcoding sensitive values. Reference modules instead of duplicating code.
- **Cloud-Init:** All VM setup is handled via the cloud-init template, not manual scripts.
- **Docker Compose Includes:** The main `compose.yaml` uses `include` to combine service definitions for maintainability.
- **Environment Variables:** Sensitive data is passed via environment variables and `.env` files, never hardcoded.
- **Healthchecks & Resource Limits:** Docker Compose services define healthchecks, restart policies, and resource limits.

### Patterns & Examples

- **Terraform Module Usage:**
  ```hcl
  module "instance" {
    source = "./modules/gitea_instance"
    project_id = var.project_id
    name = "${var.org_name}-${var.app_name}-${var.environment}"
    # ...other variables
  }
  ```
- **Docker Compose Service:**
  ```yaml
  services:
    gitea:
      image: gitea/gitea:1.22.6
      restart: always
      networks: [net]
      volumes: ["/data/gitea:/data"]
      environment:
        GITEA__server__DOMAIN: ${GITEA__server__DOMAIN:-localhost}
      healthcheck:
        test: ["CMD", "curl", "-f", "http://localhost:3000/api/healthz"]
        interval: 30s
        timeout: 10s
        retries: 5
        start_period: 30s
  ```

### Key Files

- `terraform/instance.tf` — Root Terraform config, calls modules.
- `terraform/modules/gitea_instance/instance.tf` — GCP VM module.
- `terraform/modules/gitea_instance/assets/cloud-config.yaml.tftpl` — Cloud-init template.
- `compose/compose.yaml` — Main Docker Compose entrypoint.
- `compose/compose.gitea.yml` — Gitea service definition.
- `.github/workflows/deploy.yml` — GitHub Actions deployment workflow.

### External Dependencies

- GCP (Google Cloud Platform)
- Docker & Docker Compose
- Cloudflared (Cloudflare Tunnel)
- GitHub Actions (Workload Identity Federation)

