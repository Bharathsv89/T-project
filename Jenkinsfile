pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: env.GITHUB_REPO
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
                    sh "scp -o StrictHostKeyChecking=no -i /path/to/your-key.pem install_dependencies.sh ec2-user@${publicIp}:/home/ec2-user/"
                    sh "ssh -o StrictHostKeyChecking=no -i /path/to/your-key.pem ec2-user@${publicIp} 'bash /home/ec2-user/install_dependencies.sh'"
                }
            }
        }

        stage('Build and Run Docker Container') {
            steps {
                script {
                    def publicIp = sh(script: 'terraform output public_ip', returnStdout: true).trim()
                    sh "scp -o StrictHostKeyChecking=no -i /path/to/your-key.pem Dockerfile ec2-user@${publicIp}:/home/ec2-user/"
                    sh "ssh -o StrictHostKeyChecking=no -i /path/to/your-key.pem ec2-user@${publicIp} 'docker build -t tomcat-app . && docker run -d -p 8080:8080 tomcat-app'"
                }
            }
        }
    }

    post {
        always {
            echo "Public IP of the EC2 instance: ${sh(script: 'terraform output public_ip', returnStdout: true).trim()}"
        }
    }
}