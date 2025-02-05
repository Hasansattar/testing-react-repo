pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'hasansattar/react-app:latest'
        K8S_DEPLOYMENT = 'react-app-deployment'
        K8S_NAMESPACE = 'default'
    }

    stages {
        // Clone Repository is commented out, assuming the workspace is already set

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Build React App') {
            steps {
                sh 'npm run build'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t $DOCKER_IMAGE ."
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                withDockerRegistry([credentialsId: 'docker-hub-credentials', url: 'https://index.docker.io/v1/']) {
                    sh "docker login -u hasansattar -p hasansattar650"
                    sh "docker push $DOCKER_IMAGE"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh """
                kubectl config use-context your-k8s-context
                kubectl set image deployment/$K8S_DEPLOYMENT react-container=$DOCKER_IMAGE -n $K8S_NAMESPACE
                """
            }
        }
    }
}
