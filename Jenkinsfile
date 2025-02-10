pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                cleanWs() 
                checkout scm
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
