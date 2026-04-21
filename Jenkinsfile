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

    environment {
        NEXUS_URL = 'http://192.168.100.228:8081/repository/npm-hosted/'
        PACKAGE_VERSION_BASE = '1.0.0'
        SHORT_SHA = "${env.GIT_COMMIT ? env.GIT_COMMIT.take(7) : 'localdev'}"
        PACKAGE_VERSION = "${PACKAGE_VERSION_BASE}-${SHORT_SHA}"
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
                sh '''
                    npm version "${PACKAGE_VERSION}" --no-git-tag-version
                    npm pack
                '''
                archiveArtifacts artifacts: '*.tgz', fingerprint: true
            }
        }

        stage('Publish') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'nexus-npm-creds',
                    usernameVariable: 'NEXUS_USERNAME',
                    passwordVariable: 'NEXUS_PASSWORD'
                )]) {
                    sh '''
                        cat > .npmrc <<EOF
registry=${NEXUS_URL}
always-auth=true
//192.168.100.228:8081/repository/npm-hosted/:username=${NEXUS_USERNAME}
//192.168.100.228:8081/repository/npm-hosted/:_password=$(printf "%s" "${NEXUS_PASSWORD}" | base64 | tr -d '\\n')
//192.168.100.228:8081/repository/npm-hosted/:email=ci@kijaniosk.local
//192.168.100.228:8081/repository/npm-hosted/:always-auth=true
EOF

                        npm publish --registry="${NEXUS_URL}"

                        rm -f .npmrc
                    '''
                }
            }
        }
    }

    post {
        always {
            cleanWs(deleteDirs: true, disableDeferredWipeout: true)
        }
        success {
            echo "Artifact published successfully with version ${PACKAGE_VERSION}"
            echo "Nexus URL: ${NEXUS_URL}"
        }
        failure {
            echo 'CI pipeline failed before completing all required stages.'
        }
        changed {
            echo 'Pipeline status changed compared to the previous build.'
        }
    }
}