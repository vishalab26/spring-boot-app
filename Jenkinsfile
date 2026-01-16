pipeline {
    agent any

    environment {
        DOCKER_USER = 'vishalmath2605'
        DOCKER_PASS = credentials('dockerhub-password') // Add in Jenkins credentials
        EMAIL = 'vishalmath2605@gmail.com'
    }

    // Make sure Maven is installed in Jenkins Tools
    tools {
        maven 'maven3'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/vishalab26/spring-boot-app.git'
            }
        }

        stage('Build & Package') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t $DOCKER_USER/spring-boot-app:latest .'
            }
        }

stage('Docker Push') {
    steps {
        withCredentials([string(credentialsId: 'dockerhub-password', variable: 'DOCKER_PASS')]) {
            sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
            sh 'docker push $DOCKER_USER/spring-boot-app:latest'
        }
    }
}


        stage('Trivy Scan') {
            steps {
                sh 'trivy image --exit-code 0 --severity HIGH,CRITICAL $DOCKER_USER/spring-boot-app:latest'
            }
        }
    }

    post {
        always {
            emailext(
                subject: "Jenkins Build - ${currentBuild.fullDisplayName}",
                body: "Pipeline finished. Check console output: ${env.BUILD_URL}",
                to: "${EMAIL}"
            )
        }
    }
}

