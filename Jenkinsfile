#!groovy

// Build Parameters
properties([ parameters([
  string( name: 'AWS_ACCESS_KEY_ID', defaultValue: 'AKIAJQD6BFDN6TFFY25A'),
  string( name: 'AWS_SECRET_ACCESS_KEY', defaultValue: '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')
]), pipelineTriggers([]) ])

// Environment Variables
env.AWS_ACCESS_KEY_ID = AWS_ACCESS_KEY_ID
env.AWS_SECRET_ACCESS_KEY = AWS_SECRET_ACCESS_KEY

node {
  env.PATH += ":/usr/local/bin"

  stage ('Checkout') {
    checkout scm
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

  stage ('Notification') {
    mail from: "jenkins@mycompany.com",
         to: "devopsteam@mycompany.com",
         subject: "Terraform build complete",
         body: "Jenkins job ${env.JOB_NAME} - build ${env.BUILD_NUMBER} complete"
  }
}