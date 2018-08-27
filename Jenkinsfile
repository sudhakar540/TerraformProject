pipeline {
  agent any
  tools { 
        maven 'Maven-3.5.4'
        jdk 'JDK-8'
        terraform 'Terraform 0.11.8'
  }
  stages {
    stage('Clone repository') {
        /* Let's make sure we have the repository cloned to our workspace... */
      steps {
        checkout scm
      }
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
}
