pipeline {
  agent any
  environment {
    PROJECT_DIR = 'backendP'
  }
  stages {
    stage('Checkout')      { steps { checkout scm } }
    stage('Setup Env')     {
      steps {
        bat """
          py -3 -m pip install --upgrade pip
          py -3 -m pip install -r ${PROJECT_DIR}\\requirements.txt
        """
      }
    }
    stage('Run Tests')     {
      steps {
        dir(PROJECT_DIR) {
          bat """
            REM Ejecutar pytest sólo sobre la carpeta tests
            py -3 -m pytest tests --junitxml=..\\test-results.xml --maxfail=1 --disable-warnings
          """
        }
      }
      post {
        always {
          // Jenkins recogerá el XML generado en la raíz del workspace
          junit 'test-results.xml'
        }
      }
    }
    // …resto…
  }
  post {
    always { cleanWs() }
    success { echo '✅ Pipeline exitoso' }
    failure { echo '❌ Pipeline falló' }
  }
}
