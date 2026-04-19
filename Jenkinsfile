pipeline {
    agent {
        docker {
            image 'node:18.20.4-alpine'
            args '-u root:root'
        }
    }

    options {
        timestamps()
        timeout(time: 10, unit: 'MINUTES')
    }

    stages {
        stage('Lint') {
            steps {
                sh 'npm ci'
                sh 'npm run lint'
            }
        }

        stage('Build') {
            steps {
                sh 'npm run build'
            }
        }

        stage('Test') {
            steps {
                sh 'npm test'
            }
        }
    }

    post {
        always {
            cleanWs(deleteDirs: true, disableDeferredWipeout: true)
        }
        success {
            echo 'Initial CI pipeline run succeeded.'
        }
        failure {
            echo 'Initial CI pipeline run failed.'
        }
    }
}