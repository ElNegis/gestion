pipeline {
  agent any

  environment {
    PROJECT_DIR = 'backendP'
  }

  stages {
    stage('Setup Environment') {
      steps {
        bat """
          REM usa el Python Launcher
          py -3 -m pip install --upgrade pip
          py -3 -m pip install -r backendP\requirements.txt
          py -3 -m coverage run --source=clientes_ventas_cotizaciones manage.py test --verbosity=2 --junit-xml=..\test-results.xml

        """
      }
    }

    stage('Run Tests & Coverage') {
      steps {
        dir(PROJECT_DIR) {
          bat """
            REM asegurar cobertura instalada
            py -3 -m pip install coverage
            REM ejecutar tests y generar JUnit XML
            py -3 -m coverage run --source=clientes_ventas_cotizaciones manage.py test --verbosity=2 --junit-xml=..\\test-results.xml
            py -3 -m coverage xml -o ..\\coverage-reports\\coverage.xml
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
            REM run linters
            %PYTHON% -m pylint clientes_ventas_cotizaciones --output-format=parseable --reports=y > pylint-report.txt || exit 0
            %PYTHON% -m flake8 clientes_ventas_cotizaciones --output-file=flake8-report.txt || exit 0
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
    always {
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
