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
            py -3 -m pytest --junitxml=..\\test-results.xml --maxfail=1 --disable-warnings
          """
        }
      }
      post { always { junit 'test-results.xml' } }
    }
    // …resto…
  }
  post {
    always { cleanWs() }
    success { echo '✅ Pipeline exitoso' }
    failure { echo '❌ Pipeline falló' }
  }
}
