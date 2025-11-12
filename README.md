# CI/CD Pipeline for Spring Boot Application

## Overview
This project demonstrates a complete **CI/CD pipeline** using **Jenkins**, deploying a **Spring Boot** application on AWS EC2 with Docker.  
The pipeline automates build, testing, vulnerability scanning, and deployment to staging and production environments.

---

## Tech Stack
| Purpose | Tool |
|----------|------|
| CI/CD | Jenkins |
| Source Control | GitHub |
| Build Tool | Maven |
| Containerization | Docker |
| Image Registry | Docker Hub |
| Security Scanning | Trivy |
| Cloud Provider | AWS EC2 |
| Notifications | Jenkins Email Extension |

---

## Pipeline Workflow

1. **Checkout Code** — Pulls latest code from GitHub.  
2. **Build & Test** — Executes Maven unit and integration tests.  
3. **Docker Build & Push** — Builds Docker image and pushes it to Docker Hub.  
4. **Trivy Scan** — Scans the image for vulnerabilities (HIGH, CRITICAL).  
5. **Deploy to Staging (Jenkins Server)** — Runs the app container on port `8081`.  
6. **Manual Approval** — Waits for user input to continue deployment.  
7. **Deploy to Production (EC2)** — Runs container on port `80`.  
8. **Email Notifications** — Sends success or failure email to configured address.  

---

## Jenkins Configuration

### Required Credentials
| ID | Type | Purpose |
|----|------|----------|
| `docker` | Username & Password | Docker Hub login |
| `ssh-key` | SSH Username with Private Key | EC2 connection |

---

## Project Structure
<img width="453" height="372" alt="image" src="https://github.com/user-attachments/assets/5986bf2c-bcba-4513-944e-67bc65c2f39e" />

## Deployment Verification
- Staging URL: http://<Jenkins-Server-IP>:8081
  
- Production URL: http://<EC2-Public-IP>


