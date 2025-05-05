pipeline {
  agent any

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }
    environment {
  PYTHON = 'C:\\Users\\maual\\AppData\\Local\\Programs\\Python\\Python312\\python.exe'
}

    stage('Setup Environment') {
  steps {
    bat """
      REM usa el lanzador py para invocar pip
      py -3 -m pip install --upgrade pip
      py -3 -m pip install -r backendP/requirements.txt
    """
  }
}
stage('Run Tests & Coverage') {
  steps {
    dir('backendP') {
      bat """
        REM ejecutar tests con el launcher py
        py -3 manage.py test --verbosity=2 --junit-xml=..\\test-results.xml
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
