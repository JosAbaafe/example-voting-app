pipeline {

    agent any


    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/JosAbaafe/example-voting-app.git'
            }
        }

        stage('Cleanup previous run') {
            steps {
                sh 'docker compose down --remove-orphans --volumes || true'
            }
        }

        stage('Build') {
            steps {
                sh 'docker compose build --no-cache'
            }
        }

        stage('Security Scan') {
            steps {
                script {
                    def images = [
                        'testing-pipeline-vote:latest',
                        'testing-pipeline-result:latest',
                        'testing-pipeline-worker:latest'
                    ]
                    for (image in images) {
                        sh "trivy image --scanners vuln --severity HIGH,CRITICAL --exit-code 0 ${image}"
                        sh "trivy image --scanners vuln --severity CRITICAL --ignore-unfixed --exit-code 1 ${image}"
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                // --wait blocks until all services report healthy (or fails fast
                // with a clear reason) instead of racing ahead to the next stage.
                sh 'docker compose up -d --wait --wait-timeout 120'
            }
        }

        stage('Health Check') {
            steps {
                sh 'docker compose ps'
                // Fails the stage if any service is not in a healthy/running state.
                sh '''
                    unhealthy=$(docker compose ps --format json | grep -c '"Health":"unhealthy"' || true)
                    if [ "$unhealthy" -gt 0 ]; then
                        echo "One or more services are unhealthy:"
                        docker compose ps
                        exit 1
                    fi
                '''
            }
        }
    }

    post {
        always {
            // Always capture logs before anything gets torn down or the next
            // run wipes state, so failures are debuggable after the fact.
            sh 'docker compose logs --no-color > compose.log || true'
            archiveArtifacts artifacts: 'compose.log', allowEmptyArchive: true
        }
        failure {
            sh 'docker compose down --remove-orphans || true'
        }
    }
}
