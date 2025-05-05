pipeline {
    agent any
    
    environment {
        // Variables de entorno para el proyecto
        PYTHON_VERSION = '3.9'
        PROJECT_DIR = 'backendP'
    }
    
    stages {
        stage('Checkout') {
            steps {
                // Obtener código del repositorio
                checkout scm
            }
        }
        
        stage('Setup Environment') {
            steps {
                // Configurar entorno virtual de Python
                sh '''
                    python3 -m venv venv
                    . venv/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt
                '''
            }
        }
        
        stage('Run Tests') {
            steps {
                // Ejecutar pruebas unitarias con cobertura
                sh '''
                    . venv/bin/activate
                    cd ${PROJECT_DIR}
                    python manage.py test clientes_ventas_cotizaciones --verbosity=2
                    coverage run --source=clientes_ventas_cotizaciones manage.py test clientes_ventas_cotizaciones
                    coverage report
                    coverage xml -o coverage-reports/coverage.xml
                '''
            }
            post {
                always {
                    // Publicar resultados de cobertura
                    cobertura coberturaReportFile: 'backendP/coverage-reports/coverage.xml'
                }
            }
        }
        
        stage('Code Quality') {
            steps {
                // Ejecutar análisis de calidad de código
                sh '''
                    . venv/bin/activate
                    cd ${PROJECT_DIR}
                    pylint clientes_ventas_cotizaciones --output-format=parseable --reports=y > pylint-report.txt || true
                    flake8 clientes_ventas_cotizaciones --output-file=flake8-report.txt || true
                '''
            }
            post {
                always {
                    // Publicar resultados de análisis
                    recordIssues(
                        tools: [
                            pyLint(pattern: 'backendP/pylint-report.txt'),
                            flake8(pattern: 'backendP/flake8-report.txt')
                        ]
                    )
                }
            }
        }
    }
    
    post {
        always {
            // Limpiar después de la ejecución
            cleanWs()
        }
        success {
            echo 'Pipeline ejecutado exitosamente!'
        }
        failure {
            echo 'El pipeline ha fallado.'
        }
    }
}