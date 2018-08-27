node("master") {

    stage("Prep") {
        deleteDir() // Clean up the workspace
        checkout scm    
        withCredentials([file(credentialsId: 'tfvars', variable: 'tfvars')]) {
            sh "cp $tfvars terraform.tfvars"
        }
        sh "terraform init --get=true"
    }
    stage("Plan") {
        sh "terraform plan -out=plan.out -no-color"
    }
     stage("Apply") {
        sh "terraform apply -no-color plan.out"
    }
}
