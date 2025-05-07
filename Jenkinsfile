pipeline {
  agent any

  environment {
    PROJECT_DIR = 'backend2'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Install & Test') {
      steps {
        dir(PROJECT_DIR) {
          bat 'npm ci'
          bat 'npm test'
        }
      }
      post {
        always {
          junit "${PROJECT_DIR}/junit/results.xml"
        }
      }
    }

    stage('Start Service') {
      steps {
        dir(PROJECT_DIR) {
          // Arranca el servidor en segundo plano
          bat 'start /B npm start'
          // Espera aproximadamente 5 segundos usando ping
          bat 'ping -n 6 127.0.0.1 >nul'
        }
      }
    }

    stage('Smoke Test Service') {
      steps {
        dir(PROJECT_DIR) {
          script {
            // Verifica que el batch existe en scripts/
            if (!fileExists('scripts/check_query.bat')) {
              error "❌ No encuentro ${PROJECT_DIR}/scripts/check_endpoints.bat – ¿lo has commiteado?"
            }
            // Ejecuta el batch: fallará si devuelve código distinto de 0
            bat 'scripts\\check_endpoints.bat'
          }
        }
      }
    }
  }

  post {
    always {
      dir(PROJECT_DIR) {
        // Para cualquier proceso node que haya quedado, sin abortar si falla
        bat returnStatus: true, script: 'taskkill /F /IM node.exe 2>nul || echo No hay procesos node que parar'
      }
      cleanWs()
    }
    success {
      echo '✅ Pipeline exitoso'
    }
    failure {
      echo '❌ Pipeline falló'
    }
  }
}
