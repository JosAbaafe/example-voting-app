pipeline {

    agent any


    stages {

        stage('Checkout') {
            steps {
		 sh 'git clean -fdx'
        	checkout scm
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

        stage('Deploy to Staging') {
            steps {
                sh 'docker compose -p voting-staging -f docker-compose.yml -f docker-compose.staging.yml up -d --wait --wait-timeout 120'
            }
        }

        stage('Staging Health Check') {
            steps {
                sh 'docker compose -p voting-staging -f docker-compose.yml -f docker-compose.staging.yml ps'
                sh '''
                    unhealthy=$(docker compose -p voting-staging -f docker-compose.yml -f docker-compose.staging.yml ps --format json | grep -c '"Health":"unhealthy"' || true)
                    if [ "$unhealthy" -gt 0 ]; then
                        echo "One or more staging services are unhealthy:"
                        docker compose -p voting-staging -f docker-compose.yml -f docker-compose.staging.yml ps
                        exit 1
                    fi
                '''
            }
        }

        stage('Approve Production Deploy') {
            when { branch 'main' }
            steps {
                timeout(time: 30, unit: 'MINUTES') {
                    input message: 'Deploy to Production?', ok: 'Deploy'
                }
            }
        }

        stage('Deploy to Production') {
            when { branch 'main' }
            steps {
                sh 'docker compose -p voting-prod -f docker-compose.yml -f docker-compose.prod.yml up -d --wait --wait-timeout 120'
            }
        }

        stage('Production Health Check') {
            when { branch 'main' }
            steps {
                sh 'docker compose -p voting-prod -f docker-compose.yml -f docker-compose.prod.yml ps'
                sh '''
                    unhealthy=$(docker compose -p voting-prod -f docker-compose.yml -f docker-compose.prod.yml ps --format json | grep -c '"Health":"unhealthy"' || true)
                    if [ "$unhealthy" -gt 0 ]; then
                        echo "One or more production services are unhealthy:"
                        docker compose -p voting-prod -f docker-compose.yml -f docker-compose.prod.yml ps
                        exit 1
                    fi
                '''
            }
        }

        post {
            always {
                sh 'docker compose -p voting-ci logs --no-color > compose.log || true'
                sh 'docker compose -p voting-ci down --remove-orphans || true'
                echo '=== PRINTING CRASH LOGS FOR VOTE CONTAINER ==='
            }
            ...
        }
}
}