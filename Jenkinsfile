pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "vishalmath2605/spring-boot-app"
        DOCKER_CREDENTIALS = "dockerhub"
    }

    tools {
        maven "maven3"
        jdk "java17"
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Build & Test') {
            steps {
                sh '''
                    mvn clean package -DskipTests
                '''
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                    docker build -t $DOCKER_IMAGE:latest .
                '''
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: DOCKER_CREDENTIALS,
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push $DOCKER_IMAGE:latest
                    '''
                }
            }
        }

        stage('Trivy Scan') {
            steps {
                sh '''
                    trivy image --exit-code 0 --severity HIGH,CRITICAL $DOCKER_IMAGE:latest
                '''
            }
        }

        stage('Deploy to Staging') {
            steps {
                sh '''
                    docker stop spring-staging || true
                    docker rm spring-staging || true

                    docker run -d \
                      --name spring-staging \
                      -p 8081:8080 \
                      $DOCKER_IMAGE:latest
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline completed successfully!"
        }
        failure {
            echo "❌ Pipeline failed"
        }
    }
}

