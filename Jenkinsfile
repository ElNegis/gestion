pipeline {
  agent any

  environment {
    // define once, at the top level
    PYTHON = 'C:\\Users\\maual\\AppData\\Local\\Programs\\Python\\Python312\\python.exe'
    PROJECT_DIR = 'backendP'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Setup Environment') {
      steps {
        // use the top‑level PYTHON variable
        bat """
          %PYTHON% -m pip install --upgrade pip
          %PYTHON% -m pip install -r ${PROJECT_DIR}\\requirements.txt
        """
      }
    }

    stage('Run Tests & Coverage') {
      steps {
        dir(PROJECT_DIR) {
          bat """
            REM ensure coverage is installed
            %PYTHON% -m pip install coverage
            REM run tests under coverage, output JUnit XML
            %PYTHON% -m coverage run --source=clientes_ventas_cotizaciones manage.py test --verbosity=2 --junit-xml=..\\test-results.xml
            %PYTHON% -m coverage xml -o ..\\coverage-reports\\coverage.xml
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
