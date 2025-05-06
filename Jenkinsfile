pipeline {
  agent any

  environment {
    PROJECT_DIR            = 'backendP'
    DJANGO_SETTINGS_MODULE = 'app.settings'               // <-- CAMBIADO
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Setup Environment') {
      steps {
        bat """
          py -3 -m pip install --upgrade pip
          py -3 -m pip install -r ${PROJECT_DIR}\\requirements.txt
        """
      }
    }

    stage('Prepare Test DB') {
      steps {
        dir(PROJECT_DIR) {
          bat """
            set DJANGO_SETTINGS_MODULE=${DJANGO_SETTINGS_MODULE}
            py -3 manage.py migrate --noinput
          """
        }
      }
    }

    stage('Run Tests & JUnit') {
      steps {
        dir(PROJECT_DIR) {
          bat """
            set DJANGO_SETTINGS_MODULE=${DJANGO_SETTINGS_MODULE}
            py -3 -m pytest --junitxml=..\\test-results.xml --maxfail=1 --disable-warnings
          """
        }
      }
      post {
        always { junit 'test-results.xml' }
      }
    }

    // … otros stages …
  }

  post {
    always { cleanWs() }
    success { echo '✅ Pipeline exitoso' }
    failure { echo '❌ Pipeline falló' }
  }
}
