pipeline {
  agent any

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Setup Environment') {
      steps {
        bat """
          python -m pip install --upgrade pip
          pip install -r backendP/requirements.txt
        """
      }
    }

    stage('Run Tests & Coverage') {
      steps {
        dir('backendP') {
          bat """
            REM crear carpeta de reports si no existe
            if not exist ..\\coverage-reports mkdir ..\\coverage-reports
            REM ejecutar tests con coverage
            coverage run --source=clientes_ventas_cotizaciones manage.py test --verbosity=2 --junit-xml=..\\test-results.xml
            coverage xml -o ..\\coverage-reports\\coverage.xml
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
        dir('backendP') {
          bat """
            pylint clientes_ventas_cotizaciones --output-format=parseable --reports=y > pylint-report.txt || exit 0
            flake8 clientes_ventas_cotizaciones --output-file=flake8-report.txt || exit 0
          """
        }
      }
      post {
        always {
          recordIssues tools: [
            pyLint(pattern: 'backendP/pylint-report.txt'),
            flake8(pattern: 'backendP/flake8-report.txt')
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
