pipeline {
  agent any

  environment {
    PROJECT_DIR           = 'backendP'
    // Indica cuál es tu módulo de settings
    DJANGO_SETTINGS_MODULE = 'clientes_ventas_cotizaciones.settings'
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

    stage('Prepare Test DB') {
      steps {
        dir(PROJECT_DIR) {
          bat """
            REM Exportar la variable de entorno para Django
            set DJANGO_SETTINGS_MODULE=${DJANGO_SETTINGS_MODULE}

            REM Hacer migraciones (se ejecuta sobre la base de datos de CI)
            py -3 manage.py migrate --noinput
          """
        }
      }
    }

    stage('Run Tests & JUnit') {
      steps {
        dir(PROJECT_DIR) {
          bat """
            REM Asegurar settings cargados
            set DJANGO_SETTINGS_MODULE=${DJANGO_SETTINGS_MODULE}

            REM Ejecutar pytest (detecta test/test_*.py)
            py -3 -m pytest --junitxml=..\\test-results.xml --maxfail=1 --disable-warnings
          """
        }
      }
      post {
        always {
          // Jenkins recogerá aquí los resultados
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
