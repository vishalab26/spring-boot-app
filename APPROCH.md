
---
# Approach Document — CI/CD Pipeline Implementation

## Objective
To build a fully automated CI/CD pipeline using **Jenkins** for a **Spring Boot** application, with Dockerized deployment on AWS EC2 and security scanning.

---

## Architecture Overview

The pipeline follows this workflow:
1. Developer pushes code → GitHub  
2. Jenkins triggers build → Docker agent  
3. Runs tests and builds Docker image  
4. Trivy scans image for vulnerabilities  
5. Deploys container to **staging (Jenkins server)**  
6. Waits for manual approval  
7. Deploys to **production EC2 instance**

---

## Tools Used
- **Jenkins** – CI/CD automation  
- **Maven** – Build and test automation  
- **Docker** – Containerization  
- **Trivy** – Security scanning  
- **AWS EC2** – Hosting environment  
- **Docker Hub** – Image registry  
- **Email Plugin** – Notifications  

---

## Step-by-Step Approach

### Step 1 — Setup Jenkins
- Installed Jenkins on Ubuntu EC2 instance.  
- Installed plugins:
  - Docker Pipeline
  - SSH Agent
  - Email Extension
  - Pipeline Utility Steps  

### Step 2 — Create and Configure Credentials
- Docker Hub credentials (ID: `docker`)  
- SSH Key (ID: `ssh-key`) for EC2 access  
- Configured SMTP for email alerts  

### Step 3 — Prepare Application
- Cloned a simple Spring Boot app from GitHub.  
- Added `Dockerfile` and `Jenkinsfile` in project root.  

### Step 4 — Write Jenkinsfile
Defined declarative pipeline with these stages:
1. Checkout code  
2. Build & Test with Maven  
3. Build & Push Docker image  
4. Scan image using Trivy  
5. Deploy to staging (Jenkins server)  
6. Wait for approval  
7. Deploy to production EC2  
8. Send email notification  

### Step 5 — Test the Pipeline
- Triggered pipeline from Jenkins UI  
- Verified image pushed to Docker Hub  
- Confirmed deployment on staging and production  

### Jenkins Pipeline Execution
<img width="1350" height="603" alt="image" src="https://github.com/user-attachments/assets/64102111-d477-4020-ad35-74ce31da64b4" />

---

### Trivy Scan Screenshot
<img width="817" height="221" alt="image" src="https://github.com/user-attachments/assets/8df070e6-81a5-41db-a0b3-3d65e566f4c8" />

---

### Docker image pushed to Dockerhub
<img width="1362" height="605" alt="image" src="https://github.com/user-attachments/assets/f647b936-02a4-4cf5-ae7c-584fa7606bec" />

---

### Verify Docker Image and Container
- **Pulled Docker image is listed on the server: on production server**
<img width="631" height="124" alt="image" src="https://github.com/user-attachments/assets/6411dd05-227b-4dbc-a836-c220eb6ae459" />

---
- **Running container is verified: on production server**
<img width="1102" height="96" alt="image" src="https://github.com/user-attachments/assets/4f565af6-1067-4ef8-a5d8-5282f066f99b" />

---

- **Pulled Docker image is listed on the server: on staging server**
<img width="876" height="145" alt="image" src="https://github.com/user-attachments/assets/831efac5-f5d1-4161-aaef-4e7c77adbacf" />

---
- **Running container is verified: on production server**
<img width="1105" height="102" alt="image" src="https://github.com/user-attachments/assets/41c14298-4933-455f-8c16-734fb2fb75ec" />

---

## Key Achievements
- Fully automated CI/CD process  
- Security scanning included in workflow  
- Manual approval for production deployment  
  
---

## Author
**Lavanya G.S**  
  
