# Trendify - DevOps CI/CD Project

## Project Overview

Trendify is a static web application deployed using a complete DevOps CI/CD pipeline.

The project demonstrates:

- Docker containerization
- Docker Hub image management
- Kubernetes deployment
- AWS EKS
- Jenkins CI/CD
- AWS Load Balancer
- GitHub source control

## Architecture

GitHub
   |
   v
Jenkins
   |
   v
Docker Build
   |
   v
Docker Hub
   |
   v
AWS EKS
   |
   v
Kubernetes Service
   |
   v
AWS Load Balancer
   |
   v
Trendify Web Application

## Technologies Used

- AWS EC2
- AWS EKS
- Kubernetes
- Docker
- Docker Hub
- Jenkins
- GitHub
- Nginx
- Linux Ubuntu

## Project Structure

```text
trend-app/
├── dist/
├── kubernetes/
├── Dockerfile
├── nginx.conf
├── Jenkinsfile
├── .dockerignore
└── README.md
