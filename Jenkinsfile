pipeline {

    agent any

    environment {
        DOCKER_IMAGE = 'mithungk/trend-app:v1'
        EKS_CLUSTER = 'trend-eks-cluster'
        AWS_REGION = 'ap-south-1'
    }

    stages {

        stage('Environment Check') {
            steps {
                sh '''
                    echo "======================================"
                    echo "Jenkins CI/CD Pipeline Started"
                    echo "======================================"

                    echo "Checking Docker..."
                    docker --version

                    echo "Checking kubectl..."
                    kubectl version --client

                    echo "Checking AWS CLI..."
                    aws --version
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    echo "======================================"
                    echo "Building Docker Image"
                    echo "======================================"

                    docker build -t ${DOCKER_IMAGE} .

                    echo "Docker image built successfully."
                '''
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'mithungk',
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )
                ]) {
                    sh '''
                        echo "======================================"
                        echo "Logging into Docker Hub"
                        echo "======================================"

                        echo "$DOCKER_PASSWORD" | docker login \
                            -u "$DOCKER_USERNAME" \
                            --password-stdin

                        echo "Pushing Docker image..."

                        docker push ${DOCKER_IMAGE}

                        echo "Docker image pushed successfully."
                    '''
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: 'AIDARCU2PSA3VT3BFUOCD']
                ]) {
                    sh '''
                        set -e

                        echo "======================================"
                        echo "AWS Authentication"
                        echo "======================================"

                        aws sts get-caller-identity

                        echo "======================================"
                        echo "Configuring EKS"
                        echo "======================================"

                        aws eks update-kubeconfig \
                            --region ${AWS_REGION} \
                            --name ${EKS_CLUSTER}

                        echo "======================================"
                        echo "Checking EKS Nodes"
                        echo "======================================"

                        kubectl get nodes

                        echo "======================================"
                        echo "Deploying Application"
                        echo "======================================"

                        kubectl apply -f kubernetes/deployment.yaml

                        kubectl apply -f kubernetes/service.yaml

                        echo "Application deployed successfully."
                    '''
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                sh '''
                    echo "======================================"
                    echo "Verifying Deployment"
                    echo "======================================"

                    kubectl get deployments
                    kubectl get pods
                    kubectl get services

                    echo "======================================"
                    echo "Waiting for Deployment"
                    echo "======================================"

                    kubectl rollout status deployment/trend-app --timeout=120s

                    echo "======================================"
                    echo "Deployment Verified Successfully"
                    echo "======================================"
                '''
            }
        }
    }

    post {
        success {
            echo '======================================'
            echo 'CI/CD Pipeline Completed Successfully!'
            echo '======================================'
        }

        failure {
            echo '======================================'
            echo 'CI/CD Pipeline Failed!'
            echo '======================================'
        }
    }
}
