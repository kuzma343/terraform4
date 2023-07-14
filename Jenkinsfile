pipeline {
  agent any

  stages {
    stage('Checkout') {
      steps {
        // Шаг для проверки кода из репозитория
        checkout scm
      }
    }

    stage('Terraform Init') {
      steps {
        // Инициализация Terraform
        sh 'terraform init'
      }
    }

    stage('Terraform Plan') {
      steps {
        // Создание плана изменений Terraform
        sh 'terraform plan -out=tfplan'
      }
    }
    stage('Terraform Apply') {
      steps {
        // Применение изменений Terraform
        sh 'terraform apply -auto-approve tfplan'
      }
    }
  }
}
