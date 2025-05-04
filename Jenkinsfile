pipeline {
    agent any

    stages {
        stage('Clonar código') {
            steps {
                git url: 'https://github.com/usuario/repositorio.git', credentialsId: 'github-token'
            }
        }
        stage('Build') {
            steps {
                echo 'Construyendo...'
            }
        }
        stage('Tests') {
            steps {
                echo 'Ejecutando pruebas...'
            }
        }
    }
}
