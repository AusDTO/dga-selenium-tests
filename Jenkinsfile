TOOLS_IMAGE = 'dga-tools:latest'
TOOLS_ARGS = '--volume /var/run/docker.sock:/var/run/docker.sock --volume /tmp:/tmp --network host'

pipeline {
    agent none
    triggers {
        pollSCM( '* * * * *')
        cron( 'H H(2-3) * * H(2-4)') // UTC About Midday Sydney time on a workday.
    }

    options {
        timeout(time: 1, unit: 'HOURS')
        disableConcurrentBuilds()
    }

    stages {
        
        stage('QA') {
            parallel {
                
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
