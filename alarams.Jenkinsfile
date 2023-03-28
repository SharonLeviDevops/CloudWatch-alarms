pipeline {
    agent any
    options {
         withAWS(credentials: 'aws', region: 'us-east-1')
    }
    parameters {
        choice(name: 'workspace',  choices: ['dev', 'prod'])
        choice(name: 'region', choices: ['us-east-1', 'us-east-2', 'us-west-1', 'us-west-2', 'eu-central-1', 'eu-west-1', 'eu-west-2', 'eu-west-3', 'eu-north-1'])
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
                sh 'terraform init -input=false -migrate-state'
                sh 'terraform init -input=false -reconfigure -backend-config=\'key=${params.env}-${params.region}.tfstate\''
                sh "terraform plan -input=false -out tfplan_out --var-file=regions/${params.region}-${params.workspace}.tfvars"
                sh 'terraform show -no-color tfplan_out > tfplan.txt'
            }
        }

        stage('Approval') {
            when { expression { params.autoApprove == false  } }
            steps {
                script {
                    def plan = readFile 'tfplan.txt'
                    input message: "Do you want to apply the plan?",
                        parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
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
