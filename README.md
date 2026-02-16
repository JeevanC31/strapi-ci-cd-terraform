#  Strapi CI/CD Deployment using Docker, Terraform & GitHub Actions

This project demonstrates a complete DevOps pipeline to build, push, and deploy a Strapi application automatically to AWS EC2 using:

-  Docker
-  GitHub Actions (CI/CD)
-  Terraform (Infrastructure as Code)
-  AWS EC2 (us-east-1)

---

##  Architecture Overview

1. Developer pushes code to `main`
2. GitHub Actions (CI):
   - Builds Docker image
   - Tags image using commit SHA
   - Pushes image to Docker Hub
3. GitHub Actions (CD):
   - Triggers after CI success
   - Runs Terraform
   - Creates/updates EC2
   - Pulls latest Docker image
   - Runs Strapi container automatically

---

##  Tech Stack

- **Strapi v5**
- **Node.js 20**
- **Docker**
- **Terraform**
- **AWS EC2 (t2.micro)**
- **Elastic IP**
- **GitHub Actions**
- **Docker Hub**

---

## Project Structure
```text
├── .github/workflows
│ ├── ci.yml
│ └── terraform.yml
├── strapi-app/
├── terraform/
│ ├── main.tf
│ ├── variables.tf
│ └── outputs.tf
├── Dockerfile
└── README.md

```
---

##  CI Workflow (Build & Push)

- Triggered on push to `main`
- Builds Docker image
- Tags using commit SHA
- Pushes to Docker Hub

##  CD Workflow (Terraform Deploy)

- Triggered automatically after CI success
- Uses commit SHA as image tag
- Runs:
  - `terraform init`
  - `terraform apply`
- Provisions:
  - EC2 instance
  - Security Group
  - Elastic IP
- Installs Docker
- Pulls correct image
- Runs Strapi container

---

##  AWS Infrastructure

- Region: **us-east-1 (N. Virginia)**
- Instance Type: **t2.micro**
- Swap Memory: **2GB**
- Security Group:
  - Port 22 (SSH)
  - Port 1337 (Strapi)

##  GitHub Secrets Used

- `DOCKER_USERNAME`
- `DOCKER_PASSWORD`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

---

##  Key Features

- Fully automated CI/CD
- Image tag versioning using commit SHA
- Infrastructure as Code
- Stateless deployment
- Elastic IP persistence
- Automatic EC2 recreation on change

---
