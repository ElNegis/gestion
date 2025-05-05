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

          REM Instalar dependencias desde el archivo requirements.txt dentro de backendP
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

    stage('Code Quality') {
      steps {
        dir(PROJECT_DIR) {
          bat """
            py -3 -m pylint clientes_ventas_cotizaciones --output-format=parseable --reports=y > pylint-report.txt || exit 0
            py -3 -m flake8 clientes_ventas_cotizaciones --output-file=flake8-report.txt || exit 0
          """
        }
      }
      post {
        always {
          recordIssues tools: [
            pyLint(pattern: "${PROJECT_DIR}/pylint-report.txt"),
            flake8(pattern: "${PROJECT_DIR}/flake8-report.txt")
          ]
        }
      }
    }
  }

  post {
    always { cleanWs() }
    success { echo '✅ Pipeline exitoso' }
    failure { echo '❌ Pipeline falló' }
  }
}
