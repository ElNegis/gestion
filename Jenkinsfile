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
          // Arranca en background
          bat 'start /B npm start'
          // Espera ~5s sin timeout
          bat 'ping -n 6 127.0.0.1 >nul'
        }
      }
    }

    stage('Smoke Test Service') {
      steps {
        dir(PROJECT_DIR) {
          script {
            // Verificar que el script existe
            if (!fileExists('scripts/check_endpoints.bat')) {
              error "❌ No encuentro backend2/scripts/check_endpoints.bat – ¿lo has commiteado?"
            }
            // Ejecutar el batch y fallar si devuelve código distinto de 0
            bat 'scripts\\check_endpoints.bat'
          }
        }
      }
    }
  }

  post {
    always {
      dir(PROJECT_DIR) {
        // Parar cualquier proceso node restante, pero no abortar si falla
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
