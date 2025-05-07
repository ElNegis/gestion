@echo off
setlocal enabledelayedexpansion

REM Smoke test para /api/query
REM Lanza curl y captura el código HTTP
curl -s -o nul -w %%{http_code} "http://localhost:3000/api/query?q=ci-test" > temp.txt
set /p HTTP_CODE=<temp.txt
del temp.txt

if "%HTTP_CODE%"=="200" (
  echo ✅ /api/query OK (200)
  exit /b 0
) else (
  echo ❌ /api/query falló con HTTP %HTTP_CODE%
  exit /b 1
)

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
