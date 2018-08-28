node("master") {

    stage("Prep") {
        deleteDir() // Clean up the workspace
        checkout scm    
        sh "terraform init --get=true"
    }
    stage("Apply") {
        sh "terraform apply -no-color plan.out"
    }
}
