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
          // Instala dependencias limpias
          bat 'npm ci'

          // Ejecuta los tests unitarios/integración con Jest y publica el reporte
          bat 'npm test'
        }
      }
      post {
        always {
          // Recoge los resultados JUnit (ajusta la ruta según tu configuración)
          junit "${PROJECT_DIR}/junit/results.xml"
        }
      }
    }

    stage('Start Service') {
      steps {
        dir(PROJECT_DIR) {
          // Arranca tu servidor en background
          // En Windows: start /B corre en background
          bat 'start /B npm start'

          // Espera unos segundos a que el servicio esté arriba
          bat 'timeout /T 5 /NOBREAK'
        }
      }
    }

    stage('Start Service') {
  steps {
    dir(PROJECT_DIR) {
      // Arranca el servidor en background
      bat 'start /B npm start'

      // Espera ~5 segundos haciendo ping a localhost
      bat 'ping -n 6 127.0.0.1 >nul'
    }
  }
}

  post {
    always {
      // Asegúrate de parar todos los procesos Node que levantaste
      bat 'taskkill /F /IM node.exe || echo "No hay procesos node que parar"'

      // Limpia el workspace
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
