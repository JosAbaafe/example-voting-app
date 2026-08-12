pipeline{
  agent any
  stages{
    stage('Git Check Out'){
      steps{
        git branch: 'main', url: 'https://github.com/JosAbaafe/example-voting-app.git'
      }
    }
    stage('Test'){

    }
    stage('Build Docker Image'){
      steps{
        sh 'docker build -t votingapp:${BUILD_NUMBER} .'
    }
  }
    stage('Security Checks'){
      steps{
        sh ' trivy image votingapp:${BUILD_NUMBER}'
      }
    }
}
