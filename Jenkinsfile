pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'dockerhub-jenkins-token'
        DOCKER_REGISTRY = 'https://registry.hub.docker.com'
        DOCKER_HUB_REPO = 'dennisa91/devopsprojectv2'
        IMAGE_TAG = 'latest'
        KUBECONFIG_PATH = 'C:/JenkinsKube/config'
    }

    stages {
        stage('Clone repository') {
            steps {
                git branch: 'main', url: 'https://github.com/jjac91/devopsprojectv2.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKER_HUB_REPO}:${IMAGE_TAG}")
                }
            }
        }

        stage('Push Image to DockerHub') {
            steps {
                script {
                    docker.withRegistry("${DOCKER_REGISTRY}", "${DOCKER_CREDENTIALS_ID}") {
                        dockerImage.push("${IMAGE_TAG}")
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    withEnv(["KUBECONFIG=${KUBECONFIG_PATH}"]) {
                        bat 'kubectl apply -f deployment.yaml'
                        bat 'kubectl apply -f service.yaml'
                    }
                }
            }
        }
    }

    post {
        success {
            echo '✅ Build & Deploy completed successfully!'
        }
        failure {
            echo '❌ Build & Deploy failed. Check logs.'
        }
    }
}