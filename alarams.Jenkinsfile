pipeline {
    agent any

    parameters {
        choice(name: 'env', choices: ['dev', 'prod'])
        choice(name: 'region', choices: ['us-east-1', 'us-east-2', 'us-west-1', 'us-west-2', 'eu-central-1', 'eu-west-1', 'eu-west-2', 'eu-west-3', 'eu-north-1'])
        booleanParam(name: 'autoApprove', defaultValue: false)
    }

    stages {
        stage('Workspace and Apply') {
            steps {
                sh 'terraform init -input=false'
                sh "terraform workspace new ${params.env}-${params.region} || terraform workspace select ${params.env}-${params.region}"
                sh 'terraform init -input=false -backend-config="key=${params.env}-${params.region}.tfstate"'
                sh "terraform plan -input=false -out tfplan_out -var env=${params.env} -var region=${params.region}"
                sh 'terraform show -no-color tfplan_out > tfplan.txt'
            }
        }

        stage('Approval') {
            when { expression { params.autoApprove == false } }
            steps {
                    script {
                        def plan = readFile 'tfplan.txt'
                        input message: "Do you want to apply the plan?", parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
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