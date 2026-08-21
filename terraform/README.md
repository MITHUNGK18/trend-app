# Terraform - Jenkins Infrastructure

## Objective

Terraform was used to provision an AWS EC2 instance for Jenkins and automate the Jenkins installation using EC2 user data.

## Architecture

Terraform
    |
    v
AWS EC2
    |
    +-- Ubuntu Linux
    |
    +-- Java
    |
    +-- Jenkins
    |
    +-- Security Group
    |
    +-- Port 8080

## Terraform Files

| File | Description |
|------|-------------|
| `provider.tf` | Configures the AWS provider and region |
| `main.tf` | Defines the EC2 instance and security group |
| `variable.tf` | Defines Terraform input variables |
| `outputs.tf` | Displays Jenkins public IP, DNS and URL |
| `jenkins-userdata.sh` | Installs Java and Jenkins automatically |

## Terraform Execution

The infrastructure was initialized and validated using:

```bash
terraform init
terraform validate
terraform plan
terraform apply
