# 🛒 E-Store Management System

A cloud-native, microservices-based E-Store Management System with containerization, Kubernetes orchestration, and automated deployment on Google Kubernetes Engine (GKE).

## 📋 Tech Stack

- **Backend**: Spring Boot 3.4.4 (Java 21) - REST API
- **Frontend**: React 19 + Vite - SPA
- **Database**: MySQL 8.0 - Persistent storage
- **Containerization**: Docker with multi-stage builds
- **Orchestration**: Kubernetes with Helm 3
- **Cloud**: Google Kubernetes Engine (GKE)
- **Ingress**: NGINX Ingress Controller

## 🏗️ Architecture

```
                    Internet
                        ↓
            ┌───────────────────────┐
            │  Load Balancer        │
            │  (NGINX Ingress)      │
            └───────────────────────┘
                        ↓
        ┌───────────────┴───────────────┐
        ↓                               ↓
┌──────────────────┐          ┌──────────────────┐
│  Frontend Pods   │          │  Backend Pods    │
│  (2-5 replicas)  │          │  (2-5 replicas)  │
│  React + Nginx   │          │  Spring Boot     │
│  Port: 80        │          │  Port: 8086      │
└──────────────────┘          └──────────────────┘
                                       ↓
                              ┌──────────────────┐
                              │  MySQL Pod       │
                              │  + PVC (5Gi)     │
                              └──────────────────┘
```

## ✨ Key Features

### Application
- Multi-role authentication (Admin/Buyer/Seller)
- Product catalog management
- Shopping cart & checkout
- Order tracking
- Payment integration (Razorpay)
- Email notifications

### Cloud-Native Architecture
- **Microservices**: Independent frontend, backend, and database services
- **Auto-scaling**: HPA with 2-5 replicas based on CPU (70%)
- **High Availability**: Multiple pod replicas with health checks
- **Load Balancing**: NGINX Ingress with path-based routing
- **Persistent Storage**: 5Gi PVC for MySQL
- **Zero-Downtime**: Rolling updates strategy

## 🚀 Quick Start

### Local Development

**Prerequisites:**
- Docker Desktop
- Docker Compose

**Run:**
```bash
# Start all services
docker-compose up -d --build

# Access application
Frontend: http://localhost:3000
Backend:  http://localhost:8086
MySQL:    localhost:3307
```

**Stop:**
```bash
docker-compose down
```

### GKE Deployment

**Prerequisites:**
- Google Cloud Account with billing enabled
- `gcloud` CLI installed
- `kubectl` installed
- `helm` installed
- Docker Hub account

**Deploy:**

1. **Push Docker Images:**
```bash
./push-images.sh
```

2. **Update Helm Values:**
Edit `Helm-Chart-Template/values.yaml` with your Docker Hub username:
```yaml
username: YOUR_DOCKERHUB_USERNAME
backend:
  image: YOUR_DOCKERHUB_USERNAME/estore-backend:latest
frontend:
  image: YOUR_DOCKERHUB_USERNAME/estore-frontend:latest
```

3. **Deploy to GKE:**
```bash
./deploy-to-gke.sh
```

## 📁 Project Structure

```
.
├── backend/                     # Spring Boot Backend
│   ├── src/
│   ├── pom.xml
│   └── Dockerfile
├── frontend/                    # React Frontend
│   ├── src/
│   ├── package.json
│   └── dockerfile
├── Helm-Chart-Template/         # Kubernetes Helm Charts
│   ├── Chart.yaml
│   ├── values.yaml
│   └── templates/
│       ├── backend-deployment.yaml
│       ├── frontend-deployment.yaml
│       ├── mysql-deployment.yaml
│       ├── services.yaml
│       ├── ingress.yaml
│       ├── hpa.yaml
│       └── pvc.yaml
├── docker-compose.yml           # Local development
├── push-images.sh              # Build & push images
└── deploy-to-gke.sh            # GKE deployment script
```

## 🔧 Configuration

### Backend Configuration
- **Port**: 8086
- **Database**: MySQL (jdbc:mysql://mysql:3306/lldb)
- **Endpoints**: `/admin`, `/buyer`, `/seller`, `/products`, `/orders`, `/cart`, `/payments`
- **Health Check**: `/health`

### Frontend Configuration
- **Port**: 80 (in container), 3000 (locally)
- **Backend URL**: Configured via Ingress routing

### Kubernetes Resources
- **Backend**: 2-5 replicas (CPU: 250m-500m, Memory: 512Mi-1Gi)
- **Frontend**: 2-5 replicas (CPU: 100m-250m, Memory: 256Mi-512Mi)
- **MySQL**: 1 replica with 5Gi PVC
- **HPA**: Auto-scaling based on 70% CPU utilization

## 🛠️ Technology Stack

### Backend
- Java 21
- Spring Boot 3.4.4
- Spring Data JPA
- MySQL Connector
- Razorpay SDK
- Maven

### Frontend
- React 19
- Vite
- React Router
- Axios
- Material-UI
- Tailwind CSS

### DevOps
- Docker
- Kubernetes
- Helm 3
- NGINX Ingress Controller
- Google Kubernetes Engine (GKE)

## 📊 Monitoring & Scaling

### View Resources
```bash
# All resources
kubectl get all -n estore

# HPA status
kubectl get hpa -n estore

# Pod metrics
kubectl top pods -n estore
```

### Manual Scaling
```bash
kubectl scale deployment backend --replicas=3 -n estore
kubectl scale deployment frontend --replicas=3 -n estore
```

### View Logs
```bash
kubectl logs -f deployment/backend -n estore
kubectl logs -f deployment/frontend -n estore
```

## 🔐 Security Notes

⚠️ **Important**: Update these credentials before production deployment:
- MySQL root password in `values.yaml`
- Email credentials in `values.yaml`
- Razorpay API keys in `values.yaml`

Use Kubernetes Secrets for sensitive data in production.

## 🧹 Cleanup

### Stop Local Environment
```bash
docker-compose down -v
```

### Delete GKE Deployment
```bash
helm uninstall estore -n estore
kubectl delete namespace estore
```

### Delete GKE Cluster
```bash
gcloud container clusters delete estore-cluster --zone=us-central1-a
```

## 📚 Documentation

- **README.md** - This file
- **Helm-Chart-Template/** - Complete Kubernetes manifests
- **docker-compose.yml** - Local development setup

## 🎯 Project Requirements (Tech Mahindra)

✅ **Containerization**: Docker images for all services  
✅ **Orchestration**: Kubernetes deployment with Helm  
✅ **Scalability**: HPA configured (2-5 replicas)  
✅ **High Availability**: Multiple replicas + health probes  
✅ **Ingress**: NGINX with path-based routing  
✅ **Persistent Storage**: PVC for MySQL data  
✅ **Automation**: Deployment scripts included  

## 🤝 Contributing

This project is developed for Tech Mahindra's cloud-native modernization initiative.

---

**Deployment URL**: Available after GKE deployment  
**Status**: Production-ready for Kubernetes deployment
