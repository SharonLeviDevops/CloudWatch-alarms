pipeline {
    agent any
    options {
        withAWS(credentials: 'aws', region: 'us-east-1')
    }
    environment {
        REGIONS = 'us-east-1,us-west-1,eu-central-1'
    }
    parameters {
        choice(name: 'workspace', choices: ['dev', 'prod'])
        booleanParam(name: 'autoApprove', defaultValue: false)
    }

    stages {
        stage('Plan') {
            steps {
                sh 'terraform init -input=false'
                sh """
                    if terraform workspace list | grep -q ${params.workspace}; then
                        echo "Workspace '${params.workspace}' already exists"
                        terraform workspace select ${params.workspace}
                    else
                        echo "Creating workspace '${params.workspace}'"
                        terraform workspace new ${params.workspace}
                    fi
                """
                sh "terraform init -no-color -input=false -reconfigure \
                    -backend-config=\"key=${params.workspace}${params.workspace == 'prod' ? '-us-east-1.tfstate' : '.tfstate'}\" \
                    -backend-config=\"key=${params.workspace}${params.workspace == 'prod' ? '-us-west-1.tfstate' : '.tfstate'}\" \
                    -backend-config=\"key=${params.workspace}${params.workspace == 'prod' ? '-eu-central-1.tfstate' : '.tfstate'}\""

                sh "terraform plan -no-color -input=false -out tfplan_out \
                      --var-file=regions/us-east-1-prod.tfvars \
                      --var-file=regions/us-west-1-prod.tfvars \
                      --var-file=regions/eu-central-1-prod.tfvars"
                sh 'terraform show -no-color tfplan_out > tfplan.txt'
            }
        }

        stage('Approval') {
            when {
                expression {
                    params.autoApprove == false
                }
            }
            steps {
                script {
                    def plan = readFile 'tfplan.txt'
                    input message: 'Do you want to apply the plan?',
                          parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
            }
        }

        stage('Apply') {
            steps {
                script {
                    if (params.workspace == 'dev') {
                        sh 'terraform apply -input=false tfplan_out'
                    } else if (params.workspace == 'prod') {
                        if (params.region == 'us-east-1' || params.region == 'us-west-1' || params.region == 'eu-central-1') {
                            sh 'terraform apply -input=false -target=aws_cloudwatch_metric_alarm.alarm1 -target=aws_cloudwatch_metric_alarm.alarm2 tfplan_out'
                            sh 'terraform apply -input=false -target=aws_cloudwatch_metric_alarm.alarm3 -var region=us-east-1 tfplan_out'
                        } else {
                            echo 'Invalid region specified'
                        }
                    }
                }
            }
        }
    }
    post {
        always {
            archiveArtifacts artifacts: 'tfplan.txt'
        }

        success {
            echo "Pipeline succeeded!"
        }
    }
}
