pipeline {
  agent {
    docker {
      image 'abhishekf5/maven-abhishek-docker-agent:v1'
      args '--user root -v /var/run/docker.sock:/var/run/docker.sock'
    }
  }

  environment {
    DOCKER_USER = "vishalmath2605"
    IMAGE_NAME = "spring-boot-app"
    FULL_IMAGE = "${DOCKER_USER}/${IMAGE_NAME}"
    DOCKER_HUB_CRED = credentials('dockerhub')
  }

  stages {

    stage('Checkout Code') {
      steps {
        checkout scm
      }
    }

    stage('Build & Test') {
      steps {
        sh 'mvn clean verify'
      }
    }

    stage('Docker Build & Push') {
      steps {
        sh '''
          docker build -t $FULL_IMAGE:${BUILD_NUMBER} .
          echo "$DOCKER_HUB_CRED_PSW" | docker login -u "$DOCKER_HUB_CRED_USR" --password-stdin
          docker push $FULL_IMAGE:${BUILD_NUMBER}
          docker tag $FULL_IMAGE:${BUILD_NUMBER} $FULL_IMAGE:latest
          docker push $FULL_IMAGE:latest
          docker logout
        '''
      }
    }

    stage('Trivy Image Scan') {
      steps {
        sh '''
          docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
          aquasec/trivy image --severity HIGH,CRITICAL \
          $FULL_IMAGE:${BUILD_NUMBER} > trivy-image-report.txt
        '''
      }
    }

    stage('Deploy to Staging') {
      steps {
        sh '''
          docker stop spring-staging || true
          docker rm spring-staging || true
          docker run -d -p 8081:8080 --name spring-staging $FULL_IMAGE:latest
        '''
      }
    }
  }

  post {
    always {
      archiveArtifacts artifacts: 'trivy-image-report.txt', fingerprint: true
    }

    success {
      echo "Pipeline completed successfully"
    }

    failure {
      echo "Pipeline failed"
    }
  }
}

