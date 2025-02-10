pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                cleanWs() // Очистка воркспейса
                checkout scm
            }
        }

        stage('Install zip (if needed)') {
            steps {
                sh '''
                    if ! command -v zip &> /dev/null; then
                        echo "Installing zip..."
                        if [ -f /etc/debian_version ]; then
                            apt update && apt install -y zip
                        elif [ -f /etc/redhat-release ]; then
                            yum install -y zip
                        elif [ -f /etc/alpine-release ]; then
                            apk add zip
                        else
                            echo "Unsupported OS"
                            exit 1
                        fi
                    else
                        echo "zip is already installed"
                    fi
                '''
            }
        }

        stage('Archive Files') {
            steps {
                sh 'zip -r archive.zip *'
            }
        }

        stage('Check Workspace') {
            steps {
                sh 'ls -lah'
            }
        }
    }
}
