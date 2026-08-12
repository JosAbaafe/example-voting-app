pipeline {

    agent any

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/JosAbaafe/example-voting-app.git'
            }
        }

       stage('Build') {
    steps {
        sh 'docker compose build'
    }
}

stage('Security Scan') {
    steps {
        sh 'trivy image --severity HIGH,CRITICAL votingapp:latest'
    }
}

stage('Deploy') {
    steps {
        sh 'docker compose up -d'
    }
}
    }
