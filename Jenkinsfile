node("master") {

    stage("Prep") {
        deleteDir() // Clean up the workspace
        checkout scm    
        sh "terraform init --get=true"
    }
    stage("Plan") {
        sh "terraform plan -out=plan.out -no-color"
    }
     stage("Apply") {
        sh "terraform apply -no-color plan.out"
    }
}
