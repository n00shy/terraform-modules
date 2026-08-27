# Terraform Modules – Civo Infrastructure

![Terraform](https://img.shields.io/badge/Terraform-1.15%2B-844FBA?logo=terraform&logoColor=white)
![Civo](https://img.shields.io/badge/Civo-Cloud-1E90FF)
![Infrastructure as Code](https://img.shields.io/badge/Infrastructure_as_Code-Terraform-844FBA)

A modular **Terraform Infrastructure as Code (IaC)** project for provisioning a small cloud environment on **Civo Cloud**.

The project is built as a practical DevOps/Cloud learning project and demonstrates how to separate infrastructure into reusable Terraform modules for networking, firewall configuration, and compute resources.

## 🏗️ Architecture

```text
                    Civo Cloud
                        │
                        ▼
               ┌─────────────────┐
               │ Civo Network   │
               │ devops-network  │
               └────────┬────────┘
                        │
                        ▼
               ┌─────────────────┐
               │ Civo Firewall   │
               │ devops-firewall │
               └────────┬────────┘
                        │
                        ▼
               ┌─────────────────┐
               │ Civo Instance   │
               │ devops-server   │
               │ g3.small        │
               └─────────────────┘
                        │
                        ▼
                    Public IP
                        │
                        ▼
                  SSH / Remote
```

## 📁 Project Structure

```text
terraform-modules/
├── main.tf
├── outputs.tf
├── providers.tf
├── variables.tf
├── versions.tf
├── .gitignore
├── modules/
│   ├── network/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── firewall/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── instance/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── README.md
```

## 🧩 Modules

### Network

Creates a dedicated Civo network:

```hcl
module "network" {
  source = "./modules/network"

  network_name = "devops-network"
}
```

### Firewall

Creates a firewall and attaches it to the Terraform-managed network:

```hcl
module "firewall" {
  source = "./modules/firewall"

  firewall_name = "devops-firewall"
  network_id    = module.network.network_id
}
```

### Instance

Creates a Civo compute instance and connects it to the network and firewall using an existing Civo SSH key and disk image:

```hcl
module "instance" {
  source = "./modules/instance"

  instance_name = "devops-server"
  instance_type = "g3.small"

  network_id  = module.network.network_id
  firewall_id = module.firewall.firewall_id
  ssh_key_id  = "YOUR-SSH-KEY-UUID"

  disk_image = var.disk_image
}
```

## ⚙️ Prerequisites

- Terraform `>= 1.15.0`
- A Civo Cloud account
- A valid Civo API token
- A Civo SSH key
- A valid Civo disk image UUID

## 🔐 Authentication

The Civo provider should authenticate using the `CIVO_TOKEN` environment variable rather than committing credentials to the repository.

Linux/macOS:

```bash
export CIVO_TOKEN="YOUR_CIVO_API_TOKEN"
```

For persistent configuration, store the variable in your shell environment or a secure secrets manager. **Do not commit API tokens, private SSH keys, or `terraform.tfvars` to Git.**

## 🚀 Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/n00shy/terraform-modules.git
cd terraform-modules
```

### 2. Authenticate with Civo

Set your Civo API token:

```bash
export CIVO_TOKEN="YOUR_CIVO_API_TOKEN"
```

You can also authenticate with the Civo CLI if it is already configured.

### 3. Configure variables

Create a local `terraform.tfvars` file:

```hcl
region = "nyc1"

disk_image = "YOUR-DISK-IMAGE-UUID"
```

`terraform.tfvars` is intentionally ignored by Git.

### 4. Initialize Terraform

```bash
terraform init
```

### 5. Format and validate

```bash
terraform fmt -recursive
terraform validate
```

### 6. Review the infrastructure plan

```bash
terraform plan
```

### 7. Provision the infrastructure

```bash
terraform apply
```

Confirm with `yes` when Terraform asks for approval.

## 📤 Outputs

After deployment, Terraform exposes:

- Network ID
- Firewall ID
- Instance ID
- Instance public IP

View them with:

```bash
terraform output
```

Get only the public IP:

```bash
terraform output -raw instance_public_ip
```

## 🖥️ SSH Access

The instance is configured with the Civo user and an existing Civo SSH key.

Example:

```bash
ssh -i ~/.ssh/alnoshy civo@$(terraform output -raw instance_public_ip)
```

Make sure the private key has secure permissions:

```bash
chmod 600 ~/.ssh/alnoshy
```

> Never commit the private key to Git.

## 🧹 Destroy the Infrastructure

When the lab is finished:

```bash
terraform destroy
```

Review the plan and confirm the destruction when prompted.

## 🔒 Security

This repository intentionally excludes sensitive Terraform and credential files through `.gitignore`, including:

```text
terraform.tfvars
*.tfstate
*.tfstate.*
*.pem
*.key
.terraform/
```

Never commit:

- Civo API tokens
- GitHub tokens
- SSH private keys
- Cloud credentials
- Terraform state containing sensitive information

If a credential is accidentally committed or exposed, revoke it immediately and create a replacement.

## 🎯 What This Project Demonstrates

- Infrastructure as Code with Terraform
- Terraform module design
- Reusable infrastructure components
- Civo Cloud provisioning
- Network and firewall dependencies
- Terraform variables and outputs
- Terraform state management
- SSH key-based server access
- Cloud resource dependency management
- Secure handling of credentials and state

## 🔄 Terraform Workflow

```text
Write Configuration
        │
        ▼
   terraform init
        │
        ▼
   terraform fmt
        │
        ▼
  terraform validate
        │
        ▼
   terraform plan
        │
        ▼
  terraform apply
        │
        ▼
   Civo Resources
        │
        ▼
 terraform output
        │
        ▼
 terraform destroy
```

## 📌 Future Improvements

Planned improvements for the project include:

- Add configurable firewall rules for SSH/HTTP/HTTPS
- Remove hard-coded SSH key IDs and make them variables
- Add configurable instance sizing
- Add multiple environments using Terraform workspaces or separate variable files
- Add CI validation with GitHub Actions
- Add `terraform fmt`, `validate`, and security scanning to CI
- Add reusable modules for load balancers and additional compute resources
- Add remote Terraform state for team usage

## 👨‍💻 Author

**Abdullah Ahmed (n00shy)**

Junior DevOps / Cloud Engineer focused on Linux, Docker, Kubernetes, Terraform, AWS, CI/CD, and cloud infrastructure.

- GitHub: https://github.com/n00shy
- Portfolio: https://n00shy.github.io/

---

⭐ If this project is useful, feel free to star the repository.
