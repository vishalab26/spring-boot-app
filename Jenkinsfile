pipeline {
    agent any

    environment {
        DOCKER_USER = 'vishalmath2605'
        DOCKER_PASS = credentials('docker-hub-password') // store your Docker password in Jenkins credentials
        EMAIL_RECIPIENT = 'vishalmath2605@gmail.com'
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Build & Package') {
            tools {
                maven 'Maven 3'  // Make sure Maven is installed in Jenkins Tools
            }
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    sh 'docker build -t $DOCKER_USER/spring-boot-app:latest .'
                }
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([string(credentialsId: 'docker-hub-password', variable: 'DOCKER_PASS')]) {
                    sh '''
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker push $DOCKER_USER/spring-boot-app:latest
                    '''
                }
            }
        }

        stage('Trivy Scan') {
            steps {
                sh 'trivy image --exit-code 1 --severity HIGH,CRITICAL $DOCKER_USER/spring-boot-app:latest || true'
            }
        }
    }

    post {
        always {
            echo "Pipeline finished. Sending email..."
            emailext(
                to: "${EMAIL_RECIPIENT}",
                subject: "Jenkins Pipeline: ${currentBuild.fullDisplayName}",
                body: "Pipeline finished. Check console output at ${env.BUILD_URL}"
            )
        }

        success {
            echo "✅ Build Succeeded!"
        }

        failure {
            echo "❌ Build Failed!"
        }
    }
}

