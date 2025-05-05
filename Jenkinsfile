pipeline {
  agent any

  environment {
    PROJECT_DIR = 'backendP'
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Setup Environment') {
      steps {
        bat """
          REM Actualizar pip
          py -3 -m pip install --upgrade pip

          REM Instalar dependencias
          py -3 -m pip install -r ${PROJECT_DIR}\\requirements.txt
        """
      }
    }

    stage('Run Tests & JUnit') {
      steps {
        dir(PROJECT_DIR) {
          bat """
            REM ejecutar pytest y generar XML
            py -3 -m pytest --junitxml=..\\test-results.xml --maxfail=1 --disable-warnings
          """
        }
      }
      post {
        always {
          junit 'test-results.xml'
        }
      }
    }

    // …resto de stages…
  }

  post {
    always { cleanWs() }
    success { echo '✅ Pipeline exitoso' }
    failure { echo '❌ Pipeline falló' }
  }
}
