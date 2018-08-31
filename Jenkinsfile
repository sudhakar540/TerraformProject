#!groovy

properties([ parameters([
  string( name: 'AWS_ACCESS_KEY', defaultValue: ''),
  string( name: 'AWS_SECRET_KEY', defaultValue: '')
]), pipelineTriggers([]) ])

// Environment Variables
env.AWS_ACCESS_KEY = AWS_ACCESS_KEY
env.AWS_SECRET_KEY = AWS_SECRET_KEY

node("master") {

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
       
        sh "terraform get"
        sh "set +e; terraform plan -destroy -out=plan.out -detailed-exitcode; echo \$? > status"
        def exitCode = readFile('status').trim()
        def destroy = false
        echo "Terraform Plan Exit Code: ${exitCode}"
        if (exitCode == "0") {
            currentBuild.result = 'SUCCESS'
        }
        if (exitCode == "1") {             
              currentBuild.result = 'FAILURE'
        }
        if (exitCode == "2") {
            stash name: "plan", includes: "plan.out"               
            try {
                input message: 'Destroy Plan?', ok: 'Destroy'
                destroy = true
            } catch (err) {                   
                destroy = false
                currentBuild.result = 'UNSTABLE'
            }
         }
        if (destroy) {
            stage name: 'Destroy', concurrency: 1
            unstash 'plan'
            if (fileExists("status.destroy")) {
                sh "rm status.destroy"
            }
            sh "set +e; terraform destroy -force; echo \$? > status.destroy"
            def destroyExitCode = readFile('status.destroy').trim()
            if (destroyExitCode == "0") {
                // slackSend channel: '#ci', color: 'good', message: "Changes Applied ${env.JOB_NAME} - ${env.BUILD_NUMBER} ()"    
            } else {
                // slackSend channel: '#ci', color: 'danger', message: "Destroy Failed: ${env.JOB_NAME} - ${env.BUILD_NUMBER} ()"
                currentBuild.result = 'FAILURE'
            }
        }
        sh "terraform init --get=true"
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
