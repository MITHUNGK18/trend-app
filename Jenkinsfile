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
        withCredentials([[
            $class: 'AmazonWebServicesCredentialsBinding',
            credentialsId: 'AIDARCU2PSA3VT3BFUOCD'
        ]]) {
            sh '''
                set -e

                echo "======================================"
                echo "AWS Authentication"
                echo "======================================"

                aws sts get-caller-identity

                echo "======================================"
                echo "Configuring EKS access"
                echo "======================================"

                aws eks update-kubeconfig \
                    --region ap-south-1 \
                    --name trend-eks-cluster

                echo "======================================"
                echo "Checking EKS cluster"
                echo "======================================"

                kubectl get nodes

                echo "======================================"
                echo "Deploying application"
                echo "======================================"

                kubectl apply -f kubernetes/deployment.yaml
                kubectl apply -f kubernetes/service.yaml

                echo "EKS deployment completed successfully."
            '''
        }
    }
}
