# CKA-QUIZ

This repository contains everything you need to build, version, and deploy a static website (under `docs/`) to a Kubernetes cluster on CoreWeave, using Docker, GitHub Container Registry (GHCR), and GitHub Actions.

---

## Table of Contents

1. [Overview](#overview)  
2. [Prerequisites](#prerequisites)  
3. [Getting Started](#getting-started)  
4. [Project Structure](#project-structure)  
5. [Dockerfile](#dockerfile)  
   - 👶 **Explain like I'm five**  
   - 🎓 **Graduate-level explanation**  
6. [version.txt](#versiontxt)  
   - 👶 **Explain like I'm five**  
   - 🎓 **Graduate-level explanation**  
7. [GitHub Actions Workflow](#github-actions-workflow)  
   - 👶 **Explain like I'm five**  
   - 🎓 **Graduate-level explanation**  
8. [Website Content (`docs/index.html`)](#website-content-docsindexhtml)  
   - 👶 **Explain like I'm five**  
   - 🎓 **Graduate-level explanation**  
9. [Kubernetes Manifests](#kubernetes-manifests)  
   - 👶 **Explain like I'm five**  
   - 🎓 **Graduate-level explanation**  
10. [Continuous Integration (CI) Setup](#continuous-integration-ci-setup)  
    - 👶 **Explain like I'm five**  
    - 🎓 **Graduate-level explanation**

---

## Overview

This repo automates:  
1. **Versioning** — bumping `v1`, `v2`, … whenever you change `docs/index.html`.  
2. **Container build** — packaging your site into an NGINX Docker image.  
3. **Image publish** — pushing that image to GHCR with the bumped tag.  
4. **Deploy** — updating your CoreWeave Kubernetes Deployment to use the new image.

---

## Prerequisites

- A GitHub repo with this code on the `main` branch.  
- A GitHub Container Registry (GHCR) Personal Access Token (`GHCR_PAT`) with `read:packages` & `write:packages` scopes, saved as a **repo secret**.  
- A CoreWeave kubeconfig, base64-encoded and stored as the `KUBE_CONFIG_DATA` secret.  
- `kubectl` access to your CoreWeave CKS cluster.

---

## Getting Started

1. **Clone** this repo:  
   ```bash
   git clone https://github.com/sr1ram/sr1ram.git
   cd sr1ram
   ```
2. **Edit** `docs/index.html` with your website content.  
3. **Push** your changes to `main`. The GitHub Actions workflow will:  
   - Detect your edit to `docs/index.html`  
   - Bump `version.txt` (`v1 → v2`, etc.)  
   - Build & push `ghcr.io/sr1ram/sr1ram:vN`  
   - Deploy `:vN` to your Kubernetes cluster.

---

## Project Structure

```
.
├── Dockerfile                   # Defines how to build the NGINX image
├── version.txt                  # Tracks the current version tag (e.g. v1, v2)
├── docs/
│   └── index.html               # Your website’s HTML entrypoint
├── .github/
│   └── workflows/
│       └── deploy.yml           # GitHub Actions pipeline
└── k8s/
    ├── deployment.yaml          # Kubernetes Deployment spec
    └── service.yaml             # Kubernetes Service spec (LoadBalancer)
```

---

## Dockerfile

### 👶 Explain like I’m five

This is a recipe for making a box (a “Docker image”) that holds your website.  
1. We start with a tiny web server called **NGINX**.  
2. We clean out its old stuff.  
3. We copy in **your** website pages from `docs/`.  
4. We say “please share on port 80” so you can see it in your browser.

### 🎓 Graduate-level explanation

```dockerfile
FROM nginx:stable-alpine
RUN rm -rf /usr/share/nginx/html/*
COPY docs/ /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

---

## version.txt

### 👶 Explain like I’m five

Imagine you’re building blocks and every time you change something, you add a new sticker (`v1`, `v2`, `v3`) so you know which version you’re looking at.

### 🎓 Graduate-level explanation

A simple file containing `vN`. The CI pipeline reads it, increments the integer portion, writes back the new `vN+1`, commits & tags the repository with that semantic version. This tag is then used for Docker image versioning.

---

## GitHub Actions Workflow

### 👶 Explain like I’m five

This is a robot that watches your letters (commits) to a special place (`docs/index.html`). When it sees you’ve changed your big HTML page, it:  
1. Gives you a new sticker number (`v2`).  
2. Makes a new box with your website in it (the Docker image).  
3. Sends that box to storage (GHCR).  
4. Asks the computer farm (Kubernetes) to grab the new box and put it online.

### 🎓 Graduate-level explanation

```yaml
on:
  push:
    branches: [ main ]
    paths: [ 'docs/index.html' ]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - checkout
      - bump version.txt, git commit, tag
      - docker login to GHCR
      - build-and-push Docker image tagged `:$NEW`
      - setup kubectl, write kubeconfig
      - kubectl set image deployment/sr1ram nginx=ghcr.io/sr1ram/sr1ram:$NEW
      - kubectl rollout status deployment/sr1ram
```

---

## Website Content (`docs/index.html`)

### 👶 Explain like I’m five

This is your webpage — like the picture book someone sees when they visit your site.

### 🎓 Graduate-level explanation

A static HTML file that defines the content and layout of your site. During the Docker build, it’s copied into `/usr/share/nginx/html/`, where NGINX serves it as the root document.

---

## Kubernetes Manifests

### 👶 Explain like I’m five

These are instructions for a big computer playground. One file says “start two copies of the webserver box,” and the other says “give it an address on the Internet so people can visit.”

### 🎓 Graduate-level explanation

#### `k8s/deployment.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sr1ram
spec:
  replicas: 2
  selector:
    matchLabels:
      app: sr1ram
  template:
    metadata:
      labels:
        app: sr1ram
    spec:
      containers:
      - name: nginx
        image: ghcr.io/sr1ram/sr1ram:${{ steps.bump.outputs.new_version }}
        ports:
        - containerPort: 80
        readinessProbe:
          httpGet:
            path: "/"
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 10
```

---

## Continuous Integration (CI) Setup

### 👶 Explain like I’m five

We taught our robot (GitHub Actions) how to do all the steps by itself:  
1. **Watch** the special file `docs/index.html`.  
2. **Bump** the version sticker in `version.txt`.  
3. **Build** the website box (Docker image).  
4. **Send** the box to GHCR.  
5. **Tell** Kubernetes to use the new box.  
6. **Wait** until the new website shows up.

### 🎓 Graduate-level explanation

The CI pipeline is defined in `.github/workflows/deploy.yml`. It triggers on pushes to `main` that include changes to `docs/index.html`. It runs as follows:

1. **Checkout** the repository with full history (`actions/checkout@v3` with `fetch-depth: 0`).
2. **Bump** version:
   - Reads and increments `version.txt`.
   - Commits the updated file.
   - Tags the commit with the new version.
   - Pushes the commit and tag back to `main`.
3. **Authenticate** to GHCR using either `GITHUB_TOKEN` or `GHCR_PAT` (provided via secrets) with `docker/login-action@v2`.
4. **Build & Push** the Docker image tagged `ghcr.io/sr1ram/sr1ram:vN` using `docker/build-push-action@v4`.
5. **Setup** `kubectl` (`azure/setup-kubectl@v3`) and write the CoreWeave kubeconfig from `KUBE_CONFIG_DATA` secret.
6. **Deploy** by running:
   ```bash
   kubectl --kubeconfig="$KUBECONFIG"      set image deployment/sr1ram nginx=ghcr.io/sr1ram/sr1ram:vN
   kubectl --kubeconfig="$KUBECONFIG"      rollout status deployment/sr1ram --timeout=5m
   ```
7. **Permissions**:  
   - `contents: write` for committing bumps and tags.  
   - `packages: write` for pushing images to GHCR.

This CI setup ensures end-to-end automation from content changes to production deployment, with clear versioning and reproducibility.
