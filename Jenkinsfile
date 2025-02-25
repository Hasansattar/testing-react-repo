pipeline {
    agent any

    tools {
        // Specify the NodeJS version
        nodejs 'Node18'
    }

    environment {
        // Define your Docker image tag
        DOCKER_IMAGE = 'hasansattar/react-app:latest'
        K8S_DEPLOYMENT = 'react-app-deployment'
        K8S_NAMESPACE = 'default'
    }

    stages {
        // Checkout the source code from the repository
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Hasansattar/testing-react-repo.git'
            }
        }

        // Install the dependencies using npm
        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        // Build the React app
        stage('Build React App') {
            steps {
                sh 'npm run build'
            }
        }

        // Install Docker (if it's not already installed)
        stage('Install Docker') {
            steps {
                sh '''
                apt-get update
                apt-get install -y docker.io || true
                systemctl start docker || true
                systemctl enable docker || true
                usermod -aG docker $(whoami) || true
                '''
            }
        }

        // Build the Docker image for your app
        stage('Build Docker Image') {
            steps {
                sh "DOCKER_BUILDKIT=1 docker build --pull --no-cache -t $DOCKER_IMAGE ."
            }
        }

        // Push the Docker image to Docker Hub
        stage('Push Image to Docker Hub') {
            steps {
                withDockerRegistry([credentialsId: 'docker-hub-credentials', url: 'https://index.docker.io/v1/']) {
                    sh "docker login -u hasansattar -p $DOCKER_PASSWORD"
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

    post {
        success {
            echo 'Pipeline successfully completed!'
        }

        failure {
            echo 'Pipeline failed. Check the logs for details.'
        }
    }
}
