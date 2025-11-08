#!/bin/bash

# E-Store Management System - Docker Image Build and Push Script
# This script builds and pushes Docker images to Docker Hub

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}=====================================${NC}"
echo -e "${GREEN}E-Store Management System${NC}"
echo -e "${GREEN}Docker Image Build & Push${NC}"
echo -e "${GREEN}=====================================${NC}"
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}Error: Docker is not running!${NC}"
    exit 1
fi

# Get Docker Hub username
echo -e "${YELLOW}Enter your Docker Hub username:${NC}"
read -r DOCKER_USERNAME

if [ -z "$DOCKER_USERNAME" ]; then
    echo -e "${RED}Error: Docker Hub username is required!${NC}"
    exit 1
fi

# Docker login
echo -e "${YELLOW}Logging in to Docker Hub...${NC}"
docker login

# Image names
BACKEND_IMAGE="${DOCKER_USERNAME}/estore-backend"
FRONTEND_IMAGE="${DOCKER_USERNAME}/estore-frontend"
TAG="latest"

echo ""
echo -e "${GREEN}Building images...${NC}"
echo "Backend:  ${BACKEND_IMAGE}:${TAG}"
echo "Frontend: ${FRONTEND_IMAGE}:${TAG}"
echo ""

# Build and tag backend
echo -e "${YELLOW}Building backend image...${NC}"
docker build -t ${BACKEND_IMAGE}:${TAG} ./backend

# Build and tag frontend
echo -e "${YELLOW}Building frontend image...${NC}"
docker build -t ${FRONTEND_IMAGE}:${TAG} ./frontend

# Push images
echo ""
echo -e "${YELLOW}Pushing images to Docker Hub...${NC}"
echo -e "${GREEN}Pushing backend...${NC}"
docker push ${BACKEND_IMAGE}:${TAG}

echo -e "${GREEN}Pushing frontend...${NC}"
docker push ${FRONTEND_IMAGE}:${TAG}

echo ""
echo -e "${GREEN}✅ Images successfully pushed!${NC}"
echo ""
echo "Backend:  ${BACKEND_IMAGE}:${TAG}"
echo "Frontend: ${FRONTEND_IMAGE}:${TAG}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Update Helm-Chart-Template/values.yaml with your image names"
echo "2. Deploy to GKE using: ./deploy-to-gke.sh"
echo ""
echo -e "${GREEN}Update values.yaml:${NC}"
echo "  backend.image: ${BACKEND_IMAGE}:${TAG}"
echo "  frontend.image: ${FRONTEND_IMAGE}:${TAG}"
