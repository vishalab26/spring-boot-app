pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = 'vishalmath2605'
        DOCKER_IMAGE = "${DOCKER_HUB_USER}/spring-boot-app:latest"
        MAVEN_HOME = tool name: 'Maven 3', type: 'maven'
        JAVA_HOME = tool name: 'JDK 17', type: 'jdk'
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/vishalab26/spring-boot-app.git'
            }
        }

        stage('Build & Package') {
            steps {
                withEnv(["PATH+MAVEN=${MAVEN_HOME}/bin", "JAVA_HOME=${JAVA_HOME}"]) {
                    sh 'mvn clean package -DskipTests'
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([string(credentialsId: 'docker-hub-password', variable: 'DOCKER_PASS')]) {
                    sh "echo $DOCKER_PASS | docker login -u ${DOCKER_HUB_USER} --password-stdin"
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }

        stage('Trivy Scan') {
            steps {
                sh "trivy image --exit-code 0 --severity HIGH,CRITICAL ${DOCKER_IMAGE}"
            }
        }
    }

    post {
        always {
            echo "Archiving Trivy report..."
            archiveArtifacts artifacts: 'trivy-image-report.txt', fingerprint: true
        }

        success {
            emailext subject: "✅ Build Successful - ${JOB_NAME} #${BUILD_NUMBER}",
                     body: "Spring Boot app built, Docker image pushed, and Trivy scan completed successfully.",
                     to: "vishalmath2605@gmail.com"
        }

        failure {
            emailext subject: "❌ Build Failed - ${JOB_NAME} #${BUILD_NUMBER}",
                     body: "Build, Docker push, or Trivy scan failed. Check Jenkins logs for details.",
                     to: "vishalmath2605@gmail.com"
        }
    }
}

