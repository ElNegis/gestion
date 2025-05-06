pipeline {
  agent any
  environment { PROJECT_DIR = 'backend2' }

  stages {
    stage('Install & Test') {
      steps {
        dir(PROJECT_DIR) {
          bat 'npm ci'
          bat 'npm test'
        }
      }
      post { always { junit "${PROJECT_DIR}/junit/results.xml" } }
    }
    stage('Start Service') {
      steps {
        dir(PROJECT_DIR) {
          bat 'start /B npm start'
          bat 'ping -n 6 127.0.0.1 >nul'
        }
      }
    }
    stage('Smoke Test Service') {
      steps {
        dir(PROJECT_DIR) {
          bat 'scripts\\check_query.bat'
        }
      }
    }
  }

  post {
    always {
      dir(PROJECT_DIR) {
        // Opción A con exit /b 0
        bat '''
          taskkill /F /IM node.exe 2>nul || echo No hay procesos node que parar
          exit /b 0
        '''
        // — o —
        // Opción B usando returnStatus
        // bat returnStatus: true, script: 'taskkill /F /IM node.exe 2>nul || echo No hay procesos node que parar'
      }
      cleanWs()
    }
    success { echo '✅ Pipeline exitoso' }
    failure { echo '❌ Pipeline falló' }
  }
}
