#!groovy

properties([ parameters([
  string( name: 'AWS_ACCESS_KEY', defaultValue: ''),
  string( name: 'AWS_SECRET_KEY', defaultValue: '')
]), pipelineTriggers([]) ])

// Environment Variables
env.AWS_ACCESS_KEY = AWS_ACCESS_KEY
env.AWS_SECRET_KEY = AWS_SECRET_KEY

node("NewNode") {

    stage("Prep") {
        deleteDir() // Clean up the workspace
        checkout scm 
        sh "terraform --version"
        if (fileExists(".terraform/terraform.tfstate")) {
              sh "rm -rf .terraform/terraform.tfstate"
        }
        if (fileExists("status")) {
            sh "rm status"
        }
       sh "terraform init --get=true"
        sh "terraform destroy --target=aws_instance.eip-example -auto-approve"
        
    }
    stage ('Terraform Plan') {
        sh 'terraform plan -no-color -out=create.tfplan'
    }

    // Optional wait for approval
    input 'Deploy stack?'

    stage ('Terraform Apply') {
        sh 'terraform apply -no-color create.tfplan'
    }

    stage ('Post Run Tests') {
        echo "Insert your infrastructure test of choice and/or application validation here."
        sleep 2
        sh 'terraform show'
    }
}
