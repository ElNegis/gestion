@echo off
setlocal enabledelayedexpansion

@REM REM Smoke test para /api/query
@REM REM Lanza curl y captura el código HTTP
@REM curl -s -o nul -w %%{http_code} "http://localhost:3000/api/query?q=ci-test" > temp.txt
@REM set /p HTTP_CODE=<temp.txt
@REM del temp.txt

@REM if "%HTTP_CODE%"=="200" (
@REM   echo ✅ /api/query OK (200)
@REM   exit /b 0
@REM ) else (
@REM   echo ❌ /api/query falló con HTTP %HTTP_CODE%
@REM   exit /b 1
@REM )

rem 1) GET /planchas
curl -s -o nul -w "%%{http_code}" "http://localhost:3000/planchas" > tmp.txt
set /p CODE=<tmp.txt
del tmp.txt
if NOT "!CODE!"=="200" (
  echo ❌ GET /planchas devolvió HTTP !CODE!
  exit /b 1
)
echo ✅ GET /planchas OK

rem 2) POST /planchas (crea una plancha de prueba)
curl -s -o nul -w "%%{http_code}" ^
  -H "Content-Type: application/json" ^
  -d "{\"tipo\":\"TEST\",\"ancho\":1,\"largo\":1,\"precio_unitario\":1,\"stock\":1}" ^
  "http://localhost:3000/planchas" > tmp.txt
set /p CODE=<tmp.txt
del tmp.txt
if NOT "!CODE!"=="200" (
  echo ❌ POST /planchas devolvió HTTP !CODE!
  exit /b 1
)
echo ✅ POST /planchas OK

echo 🎉 Todos los endpoints funcionaron correctamente
exit /b 0
