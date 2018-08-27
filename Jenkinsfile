node("master") {

    stage("Prep") {
        deleteDir() // Clean up the workspace
        checkout scm       
        sh "terraform init
    }
    stage("Plan") {
        sh "terraform plan
    }
     stage("Apply") {
        sh "terraform apply
    }
}
