# Trendify - Production-Ready Application Deployment

## 📌 Project Overview

This project demonstrates the deployment of the **Trendify React application** into a production-ready environment using containerization, CI/CD, Kubernetes, AWS EKS, Prometheus, and Grafana.

The application is containerized using Docker, automated through Jenkins, deployed on an Amazon EKS Kubernetes cluster, exposed externally using a Kubernetes LoadBalancer, and monitored using Prometheus and Grafana.

---

## 🏗️ Architecture

```text
                         Developer
                             │
                             ▼
                          GitHub
                             │
                             ▼
                          Jenkins
                         CI/CD Pipeline
                             │
                             ▼
                        Docker Image
                             │
                             ▼
                         AWS EKS
                    ┌────────┴────────┐
                    │                 │
                    ▼                 ▼
              Kubernetes          Monitoring
              Deployment           Namespace
                    │                 │
                    ▼          ┌──────┼─────────┐
              Trendify Pod      │      │         │
                    │           ▼      ▼         ▼
                    │      Prometheus Node   Kube State
                    │       Exporter Exporter  Metrics
                    │           │
                    ▼           ▼
              Kubernetes      Grafana
               Service           │
                    │            ▼
                    ▼       Monitoring
             AWS LoadBalancer  Dashboard
                    │
                    ▼
                   User
