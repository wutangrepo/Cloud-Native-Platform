# ☁️ Cloud-Native Platform

<p align="center">
  <img src="https://img.shields.io/badge/AWS-EKS-FF9900?style=for-the-badge&logo=amazon-aws&logoColor=white" alt="AWS EKS"/>
  <img src="https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white" alt="Terraform"/>
  <img src="https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white" alt="Docker"/>
  <img src="https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white" alt="Kubernetes"/>
  <img src="https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white" alt="GitHub Actions"/>
  <img src="https://img.shields.io/badge/Prometheus-E6522C?style=for-the-badge&logo=prometheus&logoColor=white" alt="Prometheus"/>
  <img src="https://img.shields.io/badge/Grafana-F46800?style=for-the-badge&logo=grafana&logoColor=white" alt="Grafana"/>
</p>

An end-to-end, automated deployment and monitoring platform on AWS, demonstrating modern **SRE** and **cloud-native practices** from infrastructure provisioning to application observability.

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Architecture](#-architecture)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Implementation Phases](#-implementation-phases)
- [Getting Started](#-getting-started)
- [CI/CD Pipeline](#-cicd-pipeline)
- [Monitoring & Observability](#-monitoring--observability)
- [Roadmap](#-roadmap)
- [Lessons Learned](#-lessons-learned)

---

## 🎯 Overview

This project is a **hands-on learning journey** through cloud-native technologies, building a production-grade deployment pipeline from scratch. It demonstrates practical experience with containerization, Infrastructure as Code, Kubernetes orchestration, CI/CD automation, and observability. 

### Key Highlights

- **Infrastructure as Code**: Complete AWS infrastructure provisioned with Terraform (VPC, EKS, ECR)
- **Container Orchestration**: Kubernetes deployments on Amazon EKS with managed node groups
- **Automated CI/CD**: GitHub Actions workflows for building, pushing, and deploying containers
- **Observability Stack**: Prometheus & Grafana deployed via Helm for metrics and monitoring
- **Production Practices**: Security scanning, concurrency controls, and immutable deployments

---

## 🏗 Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              AWS Cloud (eu-central-1)                       │
│  ┌───────────────────────────────────────────────────────────────────────┐  │
│  │                         VPC (10.0.0.0/16)                             │  │
│  │                                                                       │  │
│  │   ┌─────────────────────┐        ┌─────────────────────┐              │  │
│  │   │   Public Subnet 1   │        │   Public Subnet 2   │              │  │
│  │   │    (10.0.1.0/24)    │        │    (10.0.2.0/24)    │              │  │
│  │   │  ┌──────────────┐   │        │                     │              │  │
│  │   │  │ NAT Gateway  │   │        │                     │              │  │
│  │   │  └──────────────┘   │        │                     │              │  │
│  │   └─────────┬───────────┘        └─────────────────────┘              │  │
│  │             │                                                         │  │
│  │   ┌─────────▼───────────┐        ┌─────────────────────┐              │  │
│  │   │  Private Subnet 1   │        │  Private Subnet 2   │              │  │
│  │   │    (10.0.3.0/24)    │        │    (10.0.4.0/24)    │              │  │
│  │   │  ┌──────────────────┴────────┴──────────────────┐  │              │  │
│  │   │  │              EKS Cluster                     │  │              │  │
│  │   │  │  ┌─────────────────────────────────────┐     │  │              │  │
│  │   │  │  │        Managed Node Group           │     │  │              │  │
│  │   │  │  │  ┌─────────┐    ┌───────────────┐   │     │  │              │  │
│  │   │  │  │  │   App   │    │  Prometheus   │   │     │  │              │  │
│  │   │  │  │  │  Pods   │    │  & Grafana    │   │     │  │              │  │
│  │   │  │  │  └─────────┘    └───────────────┘   │     │  │              │  │
│  │   │  │  └─────────────────────────────────────┘     │  │              │  │
│  │   │  └──────────────────────────────────────────────┘  │              │  │
│  │   └────────────────────────────────────────────────────┘              │  │
│  └───────────────────────────────────────────────────────────────────────┘  │
│                                                                             │
│  ┌────────────────┐                                                         │
│  │      ECR       │  ◄──── Docker Images                                    │
│  │   Repository   │                                                         │
│  └────────────────┘                                                         │
└─────────────────────────────────────────────────────────────────────────────┘
         ▲
         │  Push Image & Deploy
         │
┌────────┴────────┐
│  GitHub Actions │
│    CI/CD        │
└─────────────────┘
```

---

## 🛠 Tech Stack

| Category | Technology |
|----------|------------|
| **Cloud Provider** | AWS (EKS, ECR, VPC, IAM) |
| **Infrastructure as Code** | Terraform (~> 1.14) |
| **Container Runtime** | Docker |
| **Container Orchestration** | Kubernetes (EKS v1.34) |
| **CI/CD** | GitHub Actions |
| **Package Manager** | Helm (~> 3.1) |
| **Monitoring** | Prometheus & Grafana (kube-prometheus-stack) |
| **Application** | Python (Flask) |
| **Project Management** | Jira (Kanban), Confluence |

---

## 📁 Project Structure

```
Cloud-Native-Platform/
├── . github/
│   └── workflows/
│       ├── ci. yaml           # Build & push Docker images to ECR
│       └── cd.yaml           # Deploy to EKS cluster
├── app/
│   ├── Dockerfile            # Container definition
│   ├── main. py               # Flask application
│   └── requirements.txt      # Python dependencies
├── k8s/
│   ├── deployment.yaml       # Kubernetes Deployment manifest
│   └── service.yaml          # Kubernetes Service (LoadBalancer)
├── terraform/
│   ├── main.tf               # VPC, ECR, EKS, IAM resources
│   ├── monitoring.tf         # Prometheus/Grafana Helm release
│   ├── providers.tf          # AWS & Helm provider configuration
│   ├── variables.tf          # Input variables
│   └── outputs. tf            # Terraform outputs
└── README.md
```

---

## 📈 Implementation Phases

This project was developed in iterative phases, each building upon the previous:

### ✅ Phase 1: The Application (Docker)
- Built a simple Python Flask application with health check endpoint
- Created an optimized Dockerfile using `python:3.9.18-slim` base image
- Validated local containerization with `docker build` and `docker run`

### ✅ Phase 2: The Foundation (Terraform & AWS)
- Designed multi-AZ VPC architecture with public and private subnets
- Configured Internet Gateway, NAT Gateway, and route tables
- Provisioned ECR repository with image scanning enabled
- Implemented proper tagging for Kubernetes integration

### ✅ Phase 3: The Pipeline (GitHub Actions - CI)
- Created CI workflow triggered on push/PR to main branch
- Implemented Docker Buildx for optimized builds with caching
- Configured AWS ECR authentication and image pushing
- Added concurrency controls to avoid race conditions

### ✅ Phase 4: The Orchestration (EKS)
- Provisioned EKS cluster (v1.34) with managed node groups
- Configured IAM roles for cluster and worker nodes
- Deployed application using Kubernetes Deployment and Service manifests
- Set up LoadBalancer service for external access

### ✅ Phase 5: Automation (CD)
- Implemented `workflow_run` trigger for reliable CI→CD chaining
- Added immutable image tags using commit SHA (not `latest`)
- Configured automatic rollout status verification
- Implemented race condition prevention with proper ref checkout

### ✅ Phase 6: Observability
- Deployed kube-prometheus-stack via Helm
- Configured Prometheus for metrics collection
- Set up Grafana for visualization and dashboards

---

## 🚀 Getting Started

### Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform >= 1.14
- kubectl
- Docker
- Helm

### Infrastructure Deployment

```bash
# Clone the repository
git clone https://github.com/wutangrepo/Cloud-Native-Platform.git
cd Cloud-Native-Platform/terraform

# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply the infrastructure
terraform apply

# Configure kubectl
aws eks update-kubeconfig --region eu-central-1 --name cloud-native-app-cluster
```

### Local Development

```bash
# Build and run the application locally
cd app
docker build -t cloud-native-app .
docker run -p 5000:5000 cloud-native-app

# Test endpoints
curl http://localhost:5000/
curl http://localhost:5000/health
```

---

## 🔄 CI/CD Pipeline

### CI Pipeline (`ci.yaml`)
```
Push to main → Checkout → Configure AWS → Login ECR → Build & Push Image
```

**Features:**
- Path-based triggers (`app/**`, `k8s/**`)
- Docker layer caching with GitHub Actions cache
- Dual tagging:  `commit-sha` + `latest`
- PR validation without pushing images

### CD Pipeline (`cd.yaml`)
```
CI Success → Checkout (specific SHA) → Configure AWS → Update Kubeconfig → Deploy to EKS
```

**Features:**
- Triggered only on successful CI completion
- Immutable deployments using commit SHA as image tag
- Rollout status verification with timeout
- Race condition prevention with explicit ref checkout

---

## 📊 Monitoring & Observability

The observability stack is deployed via Terraform using the `kube-prometheus-stack` Helm chart:

- **Prometheus**: Metrics collection and alerting
- **Grafana**:  Visualization and dashboards
- **Node Exporter**: Host-level metrics
- **kube-state-metrics**: Kubernetes object metrics

### Accessing Grafana

```bash
# Port-forward Grafana
kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80

# Access at http://localhost:3000
# Default credentials: admin / prom-operator
```

---

## 🗺 Roadmap

Future enhancements planned for this project:

- [ ] **Slack Integration**: Prometheus Alertmanager → Slack webhook for alerts
- [ ] **HashiCorp Vault**: Secrets management and rotation
- [ ] **AWS OIDC**:  Migrate from long-lived credentials to OIDC-based authentication
- [ ] **AWS Load Balancer Controller**: Migrate from classic NLB annotation
- [ ] **Remote State**: Terraform state in S3 with DynamoDB locking
- [ ] **EKS Auto Mode**: Evaluate managed node auto-scaling options
- [ ] **Private Endpoint**: Enable private EKS endpoint with SSM access

---

## 📚 Lessons Learned

### Key Takeaways

1. **Infrastructure Dependencies Matter**: Proper `depends_on` in Terraform prevents cryptic errors (e.g., IGW must exist before NAT Gateway)

2. **Immutable Deployments**: Using commit SHA instead of `latest` tag ensures reproducibility and easier rollbacks

3. **CI/CD Coupling**: Using `workflow_run` trigger prevents deployment of non-existent images

4. **Kubernetes Tagging**: Proper subnet tags (`kubernetes.io/role/elb`) are essential for LoadBalancer services

5. **Cost Awareness**: Single NAT Gateway and minimal node group sizing for learning environments

### Tools & Practices

- **Jira**: Kanban board for task tracking and sprint planning
- **Confluence**:  Technical documentation and decision records
- **Code Comments**: Extensive inline documentation explaining the "why" behind configurations

<p align="center">
  <i>Built with curiosity while learning cloud-native technologies</i>
</p>
