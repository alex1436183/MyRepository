pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                cleanWs() // Очистка воркспейса
                checkout scm
            }
        }

        stage('Check and Install zip') {
            steps {
                sh '''
                    if ! command -v zip &> /dev/null; then
                        echo "zip not found. Installing..."
                        if [ -f /etc/debian_version ]; then
                            sudo apt update && sudo apt install -y zip || true
                        elif [ -f /etc/redhat-release ]; then
                            sudo yum install -y zip || true
                        elif [ -f /etc/alpine-release ]; then
                            sudo apk add zip || true
                        else
                            echo "Unsupported OS. Skipping zip installation."
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
