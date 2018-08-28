node("master") {

    stage("Prep") {
        deleteDir() // Clean up the workspace
        checkout scm    
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
