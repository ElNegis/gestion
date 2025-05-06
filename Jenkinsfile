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
    dir(PROJECT_DIR) {
      // Aunque taskkill falle, returnStatus evita que la etapa aborte
      bat returnStatus: true, script: 'taskkill /F /IM node.exe 2>nul || echo No hay procesos node que parar'
    }
    cleanWs()
  }
}


    stage('Start Service') {
      steps {
        dir(PROJECT_DIR) {
          // Arranca tu servidor en background
          // En Windows: start /B corre en background
          bat 'start /B npm start'
// espera ~5s usando ping
          bat 'ping -n 6 127.0.0.1 >nul'  
        }
      }
    }

    stage('Smoke Test Service') {
      steps {
        dir(PROJECT_DIR) {
          // Usa tu script de comprobación para verificar /api/query
          sh 'scripts\\check_query.sh'
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
