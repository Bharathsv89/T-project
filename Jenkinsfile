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

        stage('Terraform Apply') {
            steps {
                sh '''
                    terraform init -backend-config="bucket=${S3_BUCKET}"
                    terraform apply -auto-approve
                '''
            }
        }

        stage('Get Public IP') {
            steps {
                script {
                    def publicIp = sh(script: 'terraform output public_ip', returnStdout: true).trim()
                    echo "Public IP of the EC2 instance: ${publicIp}"
                }
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
                    sh "scp -o StrictHostKeyChecking=no -i /var/lib/jenkins/vm-key.pem dockerfile ec2-user@${publicIp}:/home/ec2-user/"
                    sh "ssh -o StrictHostKeyChecking=no -i /var/lib/jenkins/vm-key.pem ec2-user@${publicIp} 'sudo docker build -t tomcat-app . && sudo docker run -d -p 8091:8091 tomcat-app'"
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
