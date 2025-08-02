## Copilot Instructions for the Gitea IaC Repository

### Project Overview

This repository provisions and manages a Gitea instance on Google Cloud Platform (GCP) using Terraform and Docker Compose. It is designed for modularity, security, and automation, with clear separation between infrastructure and application layers.

### Architecture

- **Terraform (`terraform/`)**: Provisions GCP resources (VM, disks, network, IAM, Workload Identity Federation). Uses modules for reusability (`modules/gitea_instance`, `modules/workload_identity_federation`).
- **Docker Compose (`compose/`)**: Defines containerized services (Gitea, Cloudflared) using a main `compose.yaml` that includes service-specific files.
- **Cloud-Init (`cloud-config.yaml.tftpl`)**: Bootstraps the VM with Docker, disk formatting, and prepares the environment for containers.

### Key Integration Points

- The VM is provisioned by Terraform and bootstrapped via a cloud-init template (`terraform/modules/gitea_instance/assets/cloud-config.yaml.tftpl`), which installs Docker and configures disk mounts.
- Docker Compose files are deployed on the VM. The `compose/` directory should be copied to the VM.
- Workload Identity Federation is configured in `terraform/workload_identity_federation.tf` for secure GitHub Actions deployments to GCP.

### Developer Workflows

- **Terraform (run in `terraform/`):**
  - `terraform init` — Initialize modules and providers.
  - `terraform validate` — Check configuration syntax.
  - `terraform plan` — Preview infrastructure changes.
  - `terraform apply` — Provision/update resources.

- **Connecting to the VM:**
  - Use `gcloud compute ssh` with IAP tunneling as described in `README.md` to connect securely to the VM.
  - Example command from `README.md`:
    ```bash
    SSH_USER=user
    INSTANCE_NAME=<your-instance-name>
    ZONE=<your-zone>
    PROJECT_ID=<your-project-id>
    gcloud compute ssh ${SSH_USER}@${INSTANCE_NAME} --tunnel-through-iap \
      --zone=${ZONE} --project=${PROJECT_ID}
    ```

- **Docker Compose (run on VM):**
  - To access the remote Docker daemon, set up local port forwarding as shown in `README.md`.
    ```bash
    DOCKER_HOST=tcp://127.0.0.1:12375 docker info
    ```
  - Start services: `DOCKER_HOST=tcp://127.0.0.1:12375 docker compose -f compose/compose.yaml up -d`
  - Stop services: `DOCKER_HOST=tcp://127.0.0.1:12375 docker compose -f compose/compose.yaml down`

### Project Conventions

- **Modularity:** Both Terraform and Docker Compose configurations are modular.
  - Terraform uses modules located in `terraform/modules/`.
  - Docker Compose uses multiple files included by `compose/compose.yaml`.
- **Declarative VM Setup:** The VM is configured declaratively using a `cloud-init` template (`terraform/modules/gitea_instance/assets/cloud-config.yaml.tftpl`). Avoid manual changes on the VM.
- **Terraform Cloud:** The project is set up for Terraform Cloud for state management. See `README.md` for environment variable setup.

### Key Files

- `README.md`: Contains essential setup and connection commands.
- `terraform/instance.tf`: Defines the main GCP instance using the `gitea_instance` module.
- `terraform/modules/gitea_instance/instance.tf`: The core module for the Gitea VM.
- `terraform/modules/gitea_instance/assets/cloud-config.yaml.tftpl`: Cloud-init configuration for VM bootstrapping.
- `compose/compose.yaml`: The main Docker Compose file that orchestrates the services.
- `compose/compose.gitea.yml`: Docker Compose definition for the Gitea service.
- `terraform/workload_identity_federation.tf`: Configures authentication between GitHub Actions and GCP.

### External Dependencies

- Google Cloud Platform (GCP)
- Terraform / Terraform Cloud
- Docker & Docker Compose
- Cloudflare Tunnel (via `cloudflared` container)
- GitHub Actions for CI/CD

