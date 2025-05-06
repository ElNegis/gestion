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

    stage('Smoke Test Service') {
      steps {
        dir(PROJECT_DIR) {
          // Usa tu script de comprobación para verificar /api/query
          bat 'scripts\\check_query.sh'
        }
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
