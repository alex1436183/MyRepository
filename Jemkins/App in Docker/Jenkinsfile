pipeline {
    agent { label 'minion' }

    environment {
        REPO_URL = 'https://github.com/alex1436183/tms_gr3.git'
        BRANCH_NAME = 'main'
        IMAGE_NAME = 'myapp-image'
        CONTAINER_NAME = 'myapp-container'
    }

    stages {
        stage('Clone repository') {
            steps {
                cleanWs()
                echo "Cloning repository from ${REPO_URL}"
                git branch: "${BRANCH_NAME}", url: "${REPO_URL}"
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                echo "Building Docker image..."
                docker build -f Dockerfile -t myapp-image .
                echo "Docker image built successfully!"
                '''
            }
        }

        stage('Run Tests') {
            parallel {
                stage('Run test_app.py') {
                    steps {
                        sh '''
                        echo "Running test_app.py inside Docker container..."
                        docker run --rm myapp-image pytest tests/test_app.py --maxfail=1 --disable-warnings
                        '''
                    }
                }
                stage('Run test_app2.py') {
                    steps {
                        sh '''
                        echo "Running test_app2.py inside Docker container..."
                        docker run --rm myapp-image pytest tests/test_app2.py --maxfail=1 --disable-warnings
                        '''
                    }
                }
            }
        }

        stage('Stop and Remove Old Container') {
            steps {
                sh '''
                echo "Stopping and removing old container..."
                docker stop myapp-container || true
                docker rm -f myapp-container || true
                '''
            }
        }

        stage('Run Application in Docker') {
            steps {
                sh '''
                echo "Starting application inside Docker container on port 5050..."
                docker run -d -p 5050:5050 --name myapp-container myapp-image
                echo "Application started!"
                '''
            }
        }
    }

    post {
        always {
            echo 'Build finished'
        }
        success {
            echo 'Build was successful!'
            emailext(
                subject: "Jenkins Job SUCCESS: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: "<p>Jenkins job <b>${env.JOB_NAME}</b> (<b>${env.BUILD_NUMBER}</b>) успешно выполнен!</p>" +
                      "<p>Проверить можно тут: <a href='${env.BUILD_URL}'>${env.BUILD_URL}</a></p>",
                to: 'alex1436183@gmail.com',
                mimeType: 'text/html',
                attachmentsPattern: 'reports/report.html'
            )
        }
        failure {
            echo 'Build failed!'
            emailext(
                subject: "Jenkins Job FAILED: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: "<p>Jenkins job <b>${env.JOB_NAME}</b> (<b>${env.BUILD_NUMBER}</b>) завершился с ошибкой!</p>" +
                      "<p>Логи можно посмотреть тут: <a href='${env.BUILD_URL}'>${env.BUILD_URL}</a></p>",
                to: 'alex1436183@gmail.com',
                mimeType: 'text/html',
                attachmentsPattern: 'reports/report.html'
            )
        }
    }
}
