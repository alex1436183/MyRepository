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
                        sudo apt update && sudo apt install -y zip || true
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
