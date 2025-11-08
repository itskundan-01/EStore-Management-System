#!/bin/bash

# E-Store Management System - GKE Deployment Script
# This script deploys the application to Google Kubernetes Engine

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}=====================================${NC}"
echo -e "${GREEN}E-Store Management System${NC}"
echo -e "${GREEN}GKE Deployment Script${NC}"
echo -e "${GREEN}=====================================${NC}"
echo ""

# Check if gcloud is installed
if ! command -v gcloud &> /dev/null; then
    echo -e "${RED}Error: gcloud CLI is not installed!${NC}"
    echo "Install from: https://cloud.google.com/sdk/docs/install"
    exit 1
fi

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo -e "${RED}Error: kubectl is not installed!${NC}"
    echo "Install: gcloud components install kubectl"
    exit 1
fi

# Check if helm is installed
if ! command -v helm &> /dev/null; then
    echo -e "${RED}Error: Helm is not installed!${NC}"
    echo "Install from: https://helm.sh/docs/intro/install/"
    exit 1
fi

echo -e "${YELLOW}GCP Configuration:${NC}"
echo ""

# Get GCP Project ID
echo "Enter your GCP Project ID:"
read -r PROJECT_ID

# Get GKE Cluster Name
echo "Enter GKE Cluster Name (or press Enter for 'estore-cluster'):"
read -r CLUSTER_NAME
CLUSTER_NAME=${CLUSTER_NAME:-estore-cluster}

# Get Region
echo "Enter GCP Region (or press Enter for 'us-central1'):"
read -r REGION
REGION=${REGION:-us-central1}

# Get Zone
echo "Enter GCP Zone (or press Enter for 'us-central1-a'):"
read -r ZONE
ZONE=${ZONE:-us-central1-a}

echo ""
echo -e "${GREEN}Configuration Summary:${NC}"
echo "Project ID:     $PROJECT_ID"
echo "Cluster Name:   $CLUSTER_NAME"
echo "Region:         $REGION"
echo "Zone:           $ZONE"
echo ""

read -p "Do you want to create a NEW GKE cluster? (y/n): " CREATE_CLUSTER

if [[ "$CREATE_CLUSTER" == "y" ]]; then
    echo -e "${YELLOW}Creating GKE cluster...${NC}"
    gcloud container clusters create $CLUSTER_NAME \
        --project=$PROJECT_ID \
        --zone=$ZONE \
        --num-nodes=3 \
        --machine-type=e2-medium \
        --enable-autoscaling \
        --min-nodes=2 \
        --max-nodes=5 \
        --enable-autorepair \
        --enable-autoupgrade
    
    echo -e "${GREEN}✅ Cluster created!${NC}"
fi

# Get cluster credentials
echo -e "${YELLOW}Getting cluster credentials...${NC}"
gcloud container clusters get-credentials $CLUSTER_NAME \
    --zone=$ZONE \
    --project=$PROJECT_ID

# Verify connection
echo -e "${YELLOW}Verifying cluster connection...${NC}"
kubectl cluster-info

# Create namespace
echo -e "${YELLOW}Creating namespace 'estore'...${NC}"
kubectl create namespace estore --dry-run=client -o yaml | kubectl apply -f -

# Install NGINX Ingress Controller
echo -e "${YELLOW}Installing NGINX Ingress Controller...${NC}"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.1/deploy/static/provider/cloud/deploy.yaml

echo -e "${YELLOW}Waiting for Ingress Controller to be ready...${NC}"
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s

# Deploy using Helm
echo -e "${YELLOW}Deploying E-Store Management System with Helm...${NC}"
cd Helm-Chart-Template

helm upgrade --install estore . \
    --namespace estore \
    --create-namespace \
    --wait \
    --timeout 10m

cd ..

echo ""
echo -e "${GREEN}✅ Deployment Complete!${NC}"
echo ""
echo -e "${YELLOW}Checking deployment status...${NC}"
kubectl get all -n estore

echo ""
echo -e "${YELLOW}Getting Ingress IP address...${NC}"
echo "Waiting for external IP (this may take a few minutes)..."
kubectl get ingress -n estore -w

echo ""
echo -e "${GREEN}=====================================${NC}"
echo -e "${GREEN}Useful Commands:${NC}"
echo -e "${GREEN}=====================================${NC}"
echo ""
echo "View pods:        kubectl get pods -n estore"
echo "View services:    kubectl get svc -n estore"
echo "View ingress:     kubectl get ingress -n estore"
echo "View logs:        kubectl logs -f <pod-name> -n estore"
echo "Describe pod:     kubectl describe pod <pod-name> -n estore"
echo "Helm status:      helm status estore -n estore"
echo "Uninstall:        helm uninstall estore -n estore"
echo ""
