pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-cred')
        AWS_SECRET_ACCESS_KEY = credentials('aws-passwd')
        S3_BUCKET             = 'my-s3bucket-9890'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Bharathsv89/T-project.git'
            }
        }

        stage('Install Terraform') {
            steps {
                sh '''
                    wget https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip
                    unzip terraform_1.5.7_linux_amd64.zip
                    sudo mv terraform /usr/local/bin/
                    chmod +x /usr/local/bin/terraform
                '''
            }
        }

        stage('Terraform Apply') {
            steps {
                sh '''
                    terraform init -backend-config="bucket=${S3_BUCKET}"
                    terraform apply -auto-approve
                '''
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    def publicIp = sh(script: 'terraform output public_ip', returnStdout: true).trim()
                    sh "scp -o StrictHostKeyChecking=no -i /var/lib/jenkins/vm-key.pem install_dependencies.sh ec2-user@${publicIp}:/home/ec2-user/"
                    sh "ssh -o StrictHostKeyChecking=no -i /var/lib/jenkins/vm-key.pem ec2-user@${publicIp} 'bash /home/ec2-user/install_dependencies.sh'"
                }
            }
        }

        stage('Build and Run Docker Container') {
            steps {
                script {
                    def publicIp = sh(script: 'terraform output public_ip', returnStdout: true).trim()
                    sh "scp -o StrictHostKeyChecking=no -i /var/lib/jenkins/vm-key.pem Dockerfile ec2-user@
