pipeline {

    agent any

    environment {
        DOCKER_IMAGE = "mithungk/trend-app:v1"
        DOCKER_CREDENTIALS = "mithungk"
    }

    stages {

        stage('Environment Check') {
            steps {
                sh '''
                    echo "Jenkins CI/CD Pipeline Started"
                    docker --version
                    kubectl version --client
                    aws --version
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    echo "Building Docker image..."
                    docker build -t $DOCKER_IMAGE .
                '''
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: "${DOCKER_CREDENTIALS}",
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )
                ]) {
                    sh '''
                        echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
                        docker push $DOCKER_IMAGE
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
                echo "Configuring AWS credentials..."

                aws sts get-caller-identity

                echo "Updating kubeconfig for EKS..."

                aws eks update-kubeconfig \
                    --region ap-south-1 \
                    --name trend-eks-cluster

                echo "Checking EKS cluster..."

                kubectl get nodes

                echo "Deploying application to EKS..."

                kubectl apply -f kubernetes/deployment.yaml
                kubectl apply -f kubernetes/service.yaml

                echo "Checking deployment..."

                kubectl get deployments
                kubectl get pods
                kubectl get svc

                echo "EKS deployment completed successfully."
            '''
        }
    }
}
