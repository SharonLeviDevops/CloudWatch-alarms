pipeline {
    agent any

    parameters {
        choice(name: 'workspace',  choices: ['dev', 'prod'])
        choice(name: 'region', choices: ['us-east-1', 'us-east-2', 'us-west-1', 'us-west-2', 'eu-central-1', 'eu-west-1', 'eu-west-2', 'eu-west-3', 'eu-north-1'])
        booleanParam(name: 'autoApprove', defaultValue: false)
    }

    stages {
        stage('Plan') {
            steps {
                sh 'terraform init -input=false'
                sh 'terraform workspace select ${workspace}'  // check workspace existence, create if new needed
                sh 'terraform init -input=false -backend-config="key=${params.env}-${params.region}.tfstate"'

                if (params.workspace == 'dev') {
                    sh "terraform apply -input=false -var-file=dev-${params.region}.tfvars"
                } else if (params.workspace == 'prod') {
                    if (params.region == 'us-east-1') {
                        sh "terraform apply -input=false -var-file=prod-${params.region}.tfvars -target=aws_cloudwatch_metric_alarm.alarm3"
                    } else {
                        sh "terraform apply -input=false -var-file=prod-${params.region}.tfvars"
                    }
                }

                sh 'terraform plan -input=false -out tfplan_out --var-file=${params.env}-${params.region}.tfvars'
                sh 'terraform show -no-color tfplan_out > tfplan.txt'
            }
        }

        stage('Approval') {
            when { expression { params.autoApprove == false  } }
            script {
                def plan = readFile 'tfplan.txt'
                input message: "Do you want to apply the plan?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
            }
        }

        stage('Apply') {
            steps {
                sh "terraform apply -input=false tfplan_out"
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'tfplan.txt'
        }
    }
}
