pipeline {
    agent any
    parameters {
        choice(name: 'workspace', choices: ['dev', 'prod'])
        booleanParam(name: 'autoApprove', defaultValue: false)
    }
    stages {
        stage('Plan') {
            steps {
                script {
                    def regions = ['us-east-1', 'us-west-1', 'eu-central-1']
                    for (region in regions) {
                        withAWS(credentials: 'aws', region: region) {
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
                            sh 'terraform init -no-color -input=false -reconfigure -backend-config=\'key=${params.workspace}-${region}.tfstate\''
                            sh "terraform plan -no-color -input=false -out tfplan_out --var-file=regions/${region}-${params.workspace}.tfvars"
                            sh 'terraform show -no-color tfplan_out > tfplan.txt'
                        }
                    }
                }
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

        success {
            echo "Pipeline succeeded!"
        }
    }
}
