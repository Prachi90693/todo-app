# Todo App — DevSecOps CI Pipeline

A containerized Flask todo application demonstrating production-grade DevOps practices: multi-stage Docker builds, Kubernetes manifests with health probes and rolling updates, and a GitHub Actions CI pipeline gated by Trivy vulnerability scanning.

![CI](https://github.com/Prachi90693/todo-app/actions/workflows/ci.yaml/badge.svg)

## Pipeline Architecture
## What this demonstrates

- **Multi-stage Dockerfile** — builder stage installs dependencies, runtime stage copies only what's needed; non-root user for security
- **Kubernetes manifests** — Deployment with rolling update strategy (zero downtime), liveness/readiness probes on `/health`, resource limits, ConfigMap-driven config
- **Security-gated CI** — Trivy scans every image before push; HIGH/CRITICAL findings block the pipeline. During development, Trivy caught 3 HIGH CVEs (CVE-2026-23949 and others) in python:3.11-slim — fixed by upgrading to python:3.12-slim and updating dependencies
- **Clean commit history** — incremental commits showing real development process

## Run locally

    docker build -t todo-app .
    docker run -p 5000:5000 todo-app
    # visit http://localhost:5000

## Deploy to Kubernetes

    kubectl apply -f k8s/
    kubectl port-forward svc/todo-app 8080:80
    # visit http://localhost:8080

Tested on minikube; manifests are portable to EKS or any conformant Kubernetes cluster.

## Project structure

    app.py              Flask app with /health endpoint for k8s probes
    templates/          HTML templates
    k8s/                Deployment, Service, ConfigMap
    .github/workflows/  CI pipeline (test → build → Trivy gate → push to GHCR)
    Dockerfile          Multi-stage build with non-root user
    requirements.txt    Pinned dependencies
