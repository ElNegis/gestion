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

    stage('Run Tests & Coverage') {
      steps {
        dir(PROJECT_DIR) {
          bat """
            REM Asegurar carpeta de reports
            if not exist ..\\coverage-reports mkdir ..\\coverage-reports

            REM Instalar coverage (si no viene en requirements)
            py -3 -m pip install coverage

            REM Ejecutar los tests con coverage y volcar JUnit XML
            py -3 -m coverage run --source=clientes_ventas_cotizaciones manage.py test --verbosity=2 --junit-xml=..\\test-results.xml

            REM Generar reporte de cobertura
            py -3 -m coverage xml -o ..\\coverage-reports\\coverage.xml
          """
        }
      }
      post {
        always {
          junit 'test-results.xml'
          cobertura coberturaReportFile: 'coverage-reports/coverage.xml'
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
