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
                    echo "Jenkins CI/CD Pipeline Started"

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
                    echo "Building Docker image..."

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
                        echo "Logging into Docker Hub..."

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
                     credentialsId: 'aws-credentials']
                ]) {
                    sh '''
                        echo "======================================"
                        echo "AWS Authentication"
                        echo "======================================"

                        aws sts get-caller-identity

                        echo "======================================"
                        echo "Updating EKS kubeconfig"
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

                        echo "======================================"
                        echo "Deployment Status"
                        echo "======================================"

                        kubectl get deployments

                        kubectl get pods

                        kubectl get svc

                        echo "======================================"
                        echo "EKS Deployment Completed"
                        echo "======================================"
                    '''
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                sh '''
                    echo "Waiting for deployment to become ready..."

                    kubectl rollout status deployment/trend-app --timeout=120s

                    echo "Deployment is ready."

                    kubectl get pods -o wide

                    kubectl get svc
                '''
            }
        }
    }

    post {

        success {
            echo 'CI/CD Pipeline completed successfully!'
        }

        failure {
            echo 'CI/CD Pipeline failed.'
        }

        always {
            echo 'Pipeline execution completed.'
        }
    }
}
