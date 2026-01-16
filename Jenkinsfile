pipeline {
    agent any

    environment {
        // Docker image for your app
        IMAGE_NAME = "vishalmath2605/spring-boot-app"
        // Docker Hub credentials stored in Jenkins (ID: docker)
        DOCKER_HUB_CRED = credentials('docker')
        // Production server SSH (replace with your EC2)
        DEPLOY_SERVER_PROD = "ubuntu@54.245.179.123"
    }

    stages {

        stage('Checkout Code') {
            steps {
                echo "Cloning code from GitHub..."
                checkout scm
            }
        }

        stage('Build & Package') {
            steps {
                echo "Building Spring Boot app..."
                sh "mvn clean package -DskipTests"
            }
        }

        stage('Docker Build') {
            steps {
                echo "Building Docker image..."
                sh """
                    docker build -t $IMAGE_NAME:latest .
                """
            }
        }

        stage('Docker Push') {
            steps {
                echo "Pushing Docker image to Docker Hub..."
                withCredentials([usernamePassword(credentialsId: 'docker', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push $IMAGE_NAME:latest
                        docker logout
                    """
                }
            }
        }

        stage('Trivy Scan') {
            steps {
                echo "Scanning Docker image for vulnerabilities..."
                sh """
                    docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy:latest image --exit-code 0 --severity HIGH,CRITICAL $IMAGE_NAME:latest > trivy-image-report.txt
                    echo "Trivy scan completed. Report saved."
                """
            }
        }

        stage('Deploy to Staging') {
            steps {
                echo "Deploying to staging (Jenkins server)..."
                sh """
                    docker stop spring-boot-app-staging || true
                    docker rm spring-boot-app-staging || true
                    docker run -d -p 8081:8080 --name spring-boot-app-staging $IMAGE_NAME:latest
                """
            }
        }

        stage('Approval for Production') {
            steps {
                script {
                    input message: 'Staging looks good? Approve deployment to Production?', ok: 'Deploy'
                }
            }
        }

        stage('Deploy to Production') {
            steps {
                echo "Deploying to Production server..."
                sshagent(['ssh']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no $DEPLOY_SERVER_PROD '
                            docker stop spring-boot-app || true
                            docker rm spring-boot-app || true
                            docker pull $IMAGE_NAME:latest
                            docker run -d -p 80:8080 --name spring-boot-app $IMAGE_NAME:latest
                        '
                    """
                }
            }
        }
    }

    post {
        always {
            echo "Archiving Trivy report..."
            archiveArtifacts artifacts: 'trivy-image-report.txt', fingerprint: true
        }

        success {
            echo "CI/CD Pipeline succeeded!"
            emailext subject: "Build Successful - ${JOB_NAME} #${BUILD_NUMBER}",
                     body: "Spring Boot app built, scanned, and deployed successfully.",
                     to: "gslavanyagowda@gmail.com"
        }

        failure {
            echo "Pipeline failed."
            emailext subject: "Build Failed - ${JOB_NAME} #${BUILD_NUMBER}",
                     body: "Check Jenkins logs and Trivy report for details.",
                     to: "gslavanyagowda@gmail.com"
        }
    }
}

