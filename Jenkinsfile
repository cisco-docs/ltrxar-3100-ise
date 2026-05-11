pipeline {
    agent {
        docker {
            image 'danischm/nac:0.1.6'
            label 'digidev'
            args '-u root'
        }
    }

    triggers {
        cron(env.BRANCH_NAME == 'master' ? '0 4 * * *' : '')
    }

    environment {
        ISE_USERNAME = credentials('ISE_USERNAME')
        ISE_PASSWORD = credentials('ISE_PASSWORD')
        ISE_PASSWORD_35 = credentials('ISE_PASSWORD_35')
        DD_GITHUB_TOKEN = credentials('DD_GITHUB_TOKEN')
        DD_INTERNAL_GITHUB_TOKEN = credentials('DD_INTERNAL_GITHUB_TOKEN')
        WEBEX_TOKEN = credentials('WEBEX_TOKEN')
        WEBEX_ROOM_ID = 'Y2lzY29zcGFyazovL3VzL1JPT00vNTFmMGNmODAtYjI0My0xMWU5LTljZjUtNWY0NGQ2ZTlmYWY0'
        GIT_COMMIT_MESSAGE = "${sh(returnStdout: true, script: 'git config --global --add safe.directory "*" && git log -1 --pretty=%B ${GIT_COMMIT}').trim()}"
        GIT_COMMIT_AUTHOR = "${sh(returnStdout: true, script: 'git show -s --pretty=%an').trim()}"
        GIT_EVENT = "${(env.CHANGE_ID != null) ? 'Pull Request' : 'Push'}"
    }

    options {
        disableConcurrentBuilds()
        newContainerPerStage()
        timeout(time: 1, unit: 'HOURS')
    }

    stages {
        stage('Lint') {
            steps {
                sh 'yamllint -s .'
                sh 'pytest -m validate'
            }
        }
        stage('Publish Documentation') {
            when {
                branch 'master'
            }
            steps {
                build job: '/netascode/netascode/master', wait: false
            }
        }
        stage('Test') {
            parallel {
                stage('Test 3.2') {
                    when {
                        expression { return false } // DISABLED: skipped temporary due to possible defect - remove this block to re-enable
                    }
                    steps {
                        lock(resource: 'nac-ci-ise1-3.2') {
                            sh 'pytest -m ise_32'
                        }
                    }
                    post {
                        always {
                            junit 'ise_tf_3.2_xunit.xml'
                            archiveArtifacts 'ise_tf_3.2_*.html, ise_tf_3.2_*.xml'
                        }
                    }
                }
                stage('Test 3.3') {
                    steps {
                        lock(resource: 'nac-ci-ise1-3.3') {
                            sh 'pytest -m ise_33'
                        }
                    }
                    post {
                        always {
                            junit 'ise_tf_3.3_xunit.xml'
                            archiveArtifacts 'ise_tf_3.3_*.html, ise_tf_3.3_*.xml'
                        }
                    }
                }
                stage('Test 3.4') {
                    steps {
                        lock(resource: 'nac-ci-ise1-3.4') {
                            sh 'pytest -m ise_34'
                        }
                    }
                    post {
                        always {
                            junit 'ise_tf_3.4_xunit.xml'
                            archiveArtifacts 'ise_tf_3.4_*.html, ise_tf_3.4_*.xml'
                        }
                    }
                }
                stage('Test 3.5') {
                    steps {
                        lock(resource: 'nac-ci-ise1-3.5') {
                            sh 'pytest -m ise_35'
                        }
                    }
                    post {
                        always {
                            junit 'ise_tf_3.5_xunit.xml'
                            archiveArtifacts 'ise_tf_3.5_*.html, ise_tf_3.5_*.xml'
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                if (env.BRANCH_NAME == "master") {
                    sh 'cd scripts && python3 update_repos.py'
                }
            }
            sh "BUILD_STATUS=${currentBuild.currentResult} python3 .ci/webex-notification-jenkins.py"
            cleanWs()
        }
    }
}
