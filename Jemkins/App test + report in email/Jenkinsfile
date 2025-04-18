pipeline {
    agent { label 'minion' }
    environment {
        DEPLOY_DIR = "${HOME}/deploy"
    }
    stages {
        stage('Checkout') {
            steps {
                cleanWs()
                git branch: 'main', url: 'https://github.com/alex1436183/avl_test'
            }
        }
        stage('Setup Python Environment') {
            steps {
                sh '''#!/bin/bash
                python3 -m venv venv
                . venv/bin/activate
                pip install unittest-xml-reporting pytest pytest-html
                '''
            }
        }
        stage('Run Calculator Tests') {
            steps {
                sh '''#!/bin/bash
                . venv/bin/activate
                python3 -m xmlrunner discover -v -o test-results || true
                '''
            }
            post {
                always {
                    junit 'test-results/*.xml'
                }
            }
        }
        stage('Run Calculator Interactive') {
            steps {
                sh '''#!/bin/bash
                . venv/bin/activate
                python3 calculator.py <<EOF
1
5
7
EOF'''
            }
        }
        stage('Generate Test Report') {
            steps {
                sh '''#!/bin/bash
                . venv/bin/activate
                mkdir -p reports
                pytest --html=reports/report.html --self-contained-html || true
                '''
            }
        }
        stage('Publish Test Report') {
            steps {
                publishHTML (target: [
                    allowMissing: true,
                    alwaysLinkToLastBuild: true,
                    keepAll: true,
                    reportDir: 'reports',
                    reportFiles: 'report.html',
                    reportName: 'HTML Test Report'
                ])
            }
        }
        stage('Create Directory for Deployment') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'agent-ssh-key', keyFileVariable: 'SSH_KEY')]) {
                    sh '''#!/bin/bash
                    ssh -i "$SSH_KEY" jenkins@minion "mkdir -p ${DEPLOY_DIR}"'''
                }
            }
        }
        stage('Deploy') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'agent-ssh-key', keyFileVariable: 'SSH_KEY')]) {
                    sh '''#!/bin/bash
                    tar czf - * | ssh -i "$SSH_KEY" jenkins@minion "tar xzf - -C ${DEPLOY_DIR}"'''
                }
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
                body: "<p>Jenkins job <b>${env.JOB_NAME}</b> (<b>${env.BUILD_NUMBER}</b>) успешно выполнен!</p><p>Проверить можно тут: <a href='${env.BUILD_URL}'>${env.BUILD_URL}</a></p>",
                to: 'alex1436183@gmail.com',
                mimeType: 'text/html',
                attachmentsPattern: 'reports/report.html'  // Указываем путь к файлу отчета
            )
        }
        failure {
            echo 'Build failed!'
            emailext(
                subject: "Jenkins Job FAILED: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: "<p>Jenkins job <b>${env.JOB_NAME}</b> (<b>${env.BUILD_NUMBER}</b>) завершился с ошибкой!</p><p>Логи можно посмотреть тут: <a href='${env.BUILD_URL}'>${env.BUILD_URL}</a></p>",
                to: 'alex1436183@gmail.com',
                mimeType: 'text/html',
                attachmentsPattern: 'reports/report.html'  // Указываем путь к файлу отчета
            )
        }
    }
}
