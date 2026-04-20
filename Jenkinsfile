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

        stage('Verify') {
            parallel {
                stage('Test') {
                    steps {
                        sh 'npm test'
                    }
                }

                stage('Security Audit') {
                    steps {
                        sh 'npm audit --audit-level=high'
                    }
                }
            }
        }

        stage('Archive') {
            steps {
                sh 'npm pack'
                archiveArtifacts artifacts: '*.tgz', fingerprint: true
            }
        }
    }

    post {
        always {
            cleanWs(deleteDirs: true, disableDeferredWipeout: true)
        }
        success {
            echo 'CI pipeline completed successfully through archive stage.'
        }
        failure {
            echo 'CI pipeline failed before completing all required stages.'
        }
        changed {
            echo 'Pipeline status changed compared to the previous build.'
        }
    }
}