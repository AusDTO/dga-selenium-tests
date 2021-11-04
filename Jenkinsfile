TOOLS_IMAGE = 'dga-tools:latest'
TOOLS_ARGS = '--volume /var/run/docker.sock:/var/run/docker.sock --volume /tmp:/tmp --network host'

/*
 * UTC About Midday Sydney time on a Tuesday->Thursday for Prod/Identity,
 * any work hour for Dev/Staging/Pipeline.
 */
CRON_TAB = BRANCH_NAME ==~ /(Production|Identity)/ ? "H H(2-3) * * H(2-4)" : BRANCH_NAME ==~ /(Develop|Staging|Pipeline)/ ? "H H(0-5) * * H(1-5)": ""

pipeline {
    agent none
    triggers {
        pollSCM( '* * * * *')
        cron( CRON_TAB)
    }

    options {
        timeout(time: 1, unit: 'HOURS')
        disableConcurrentBuilds()
    }

    stages {
        
        stage('QA') {
            parallel {
                stage('scan-secrets'){
                    agent {
                        docker {
                            image TOOLS_IMAGE
                            args TOOLS_ARGS
                        }
                    }
                    steps {
                        sh './secrets_scan.sh'
                    }
                }
                stage('production-chrome') {
                    agent {
                        docker {
                            image TOOLS_IMAGE
                            args TOOLS_ARGS
                        }
                    }

                    steps {
                        sh '''\
                            #!/bin/bash
                            set -ex

                            ./pullRunner.sh
                            ./test.sh --browser chrome --base-url https://data.gov.au

                        '''.stripIndent()
                    }
                    post {
                        always {
                            junit '.output/**/*.xml*'
                        }
                    }
                }
                stage('production-firefox') {
                    agent {
                        docker {
                            image TOOLS_IMAGE
                            args TOOLS_ARGS
                        }
                    }

                    steps {
                        sh '''\
                            #!/bin/bash
                            set -ex

                            ./pullRunner.sh
                            ./test.sh --browser firefox --base-url https://data.gov.au

                        '''.stripIndent()
                    }
                    post {
                        always {
                            junit '.output/**/*.xml*'
                        }
                    }
                }    

                stage('staging-chrome') {
                     agent {
                        docker {
                            image TOOLS_IMAGE
                            args TOOLS_ARGS
                        }
                    }

                    steps {
                        sh '''\
                            #!/bin/bash
                            docker ps
                            docker images
                        '''.stripIndent()

                        sh '''\
                            #!/bin/bash
                            set -ex
                            ./pullRunner.sh
                            ./test.sh --browser chrome --base-url https://staging.data.gov.au

                        '''.stripIndent()
                    }
                    post {
                        always {
                            junit '.output/**/*.xml*'
                        }
                    }
                }
                stage('staging-firefox') {
                    agent {
                        docker {
                            image TOOLS_IMAGE
                            args TOOLS_ARGS
                        }
                    }

                    steps {
                        sh '''\
                            #!/bin/bash
                            set -ex

                            ./pullRunner.sh
                            ./test.sh --browser firefox --base-url https://staging.data.gov.au

                        '''.stripIndent()
                    }
                    post {
                        always {
                            junit '.output/**/*.xml*'
                        }
                    }
                }    
            }
        }
    }
}
