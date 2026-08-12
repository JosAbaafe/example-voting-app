pipeline {

    agent any

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/JosAbaafe/example-voting-app.git'
            }
        }

        stage('Test') {
            steps {
                echo 'Running application tests...'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t votingapp:${BUILD_NUMBER} .'
            }
        }

        stage('Trivy Security Scan') {
           steps {
                sh "trivy image --severity HIGH,CRITICAL myapp:${BUILD_NUMBER}"
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }

        failure {
            echo 'Pipeline failed. Check the console output.'
        }
    }
}
