# Configuraciu00f3n de Jenkins con GitHub

Este documento explica cu00f3mo configurar Jenkins para integrarse con GitHub y ejecutar pruebas unitarias automu00e1ticamente cuando se realicen cambios en el repositorio.

## Requisitos previos

1. Un servidor Jenkins instalado y funcionando
2. Un repositorio GitHub con el cu00f3digo del proyecto
3. Permisos de administrador en Jenkins
4. Permisos de administrador en el repositorio GitHub

## Pasos para la configuraciu00f3n

### 1. Instalar plugins necesarios en Jenkins

1. Inicia sesiu00f3n en Jenkins como administrador
2. Ve a "Administrar Jenkins" > "Administrar Plugins"
3. En la pestau00f1a "Disponibles", busca e instala los siguientes plugins:
   - GitHub Integration
   - Pipeline
   - Blue Ocean (opcional, pero recomendado para una mejor interfaz)
   - Cobertura Plugin (para informes de cobertura)
   - Warnings Next Generation (para anu00e1lisis de cu00f3digo)

### 2. Configurar credenciales de GitHub en Jenkins

1. Ve a "Administrar Jenkins" > "Administrar Credenciales"
2. Haz clic en el dominio global ("global")
3. Haz clic en "Au00f1adir credenciales"
4. Selecciona "GitHub Personal Access Token" como tipo
5. Ingresa tu token de acceso personal de GitHub (necesitaru00e1s crear uno en GitHub con permisos de repo y admin:repo_hook)
6. Asigna un ID y descripciu00f3n para identificar estas credenciales
7. Haz clic en "OK"

### 3. Configurar el webhook de GitHub

#### Opciu00f3n 1: Configuraciu00f3n automu00e1tica (recomendada)

1. Ve a "Administrar Jenkins" > "Configurar Sistema"
2. Busca la secciu00f3n "GitHub"
3. Haz clic en "Au00f1adir GitHub Server"
4. Proporciona un nombre para la configuraciu00f3n
5. Selecciona las credenciales que creaste anteriormente
6. Marca la opciu00f3n "Administrar hooks"
7. Haz clic en "Guardar"

#### Opciu00f3n 2: Configuraciu00f3n manual

1. Ve a tu repositorio en GitHub
2. Ve a "Settings" > "Webhooks" > "Add webhook"
3. En "Payload URL", ingresa: `https://[tu-servidor-jenkins]/github-webhook/`
4. Selecciona "application/json" como Content type
5. En "Which events would you like to trigger this webhook?", selecciona "Just the push event"
6. Asegu00farate de que "Active" estu00e9 marcado
7. Haz clic en "Add webhook"

### 4. Crear un nuevo pipeline en Jenkins

1. En Jenkins, haz clic en "Nueva tarea"
2. Ingresa un nombre para el pipeline (por ejemplo, "backend-tests")
3. Selecciona "Pipeline" como tipo de proyecto
4. Haz clic en "OK"
5. En la configuraciu00f3n del pipeline:
   - En la secciu00f3n "General", marca "GitHub project" e ingresa la URL de tu repositorio
   - En la secciu00f3n "Build Triggers", marca "GitHub hook trigger for GITScm polling"
   - En la secciu00f3n "Pipeline", selecciona "Pipeline script from SCM"
   - Selecciona "Git" como SCM
   - Ingresa la URL del repositorio
   - Selecciona las credenciales adecuadas
   - En "Branch Specifier", ingresa "*/main" (o la rama que desees monitorear)
   - En "Script Path", ingresa "Jenkinsfile" (asegu00farate de que este archivo exista en la rau00edz de tu repositorio)
6. Haz clic en "Guardar"

## Verificaciu00f3n

Para verificar que todo estu00e1 configurado correctamente:

1. Realiza un cambio en tu repositorio y haz push a la rama configurada
2. Ve a Jenkins y verifica que se inicie automu00e1ticamente una nueva ejecuciu00f3n del pipeline
3. Revisa los resultados de la ejecuciu00f3n para asegurarte de que las pruebas se ejecuten correctamente

## Soluciu00f3n de problemas

- Si el webhook no se activa, verifica la configuraciu00f3n del webhook en GitHub y asegu00farate de que la URL sea accesible desde Internet
- Si las pruebas fallan, revisa los logs de Jenkins para identificar el problema
- Asegu00farate de que los requisitos del proyecto estu00e9n correctamente especificados en el archivo requirements.txt

## Notas adicionales

- Para entornos de producciu00f3n, considera configurar etapas adicionales en el pipeline para despliegue automu00e1tico
- Puedes configurar notificaciones por correo electru00f3nico o integraciones con Slack para recibir alertas sobre el estado de las ejecuciones
- Considera implementar pruebas de integraciu00f3n y pruebas end-to-end ademu00e1s de las pruebas unitarias