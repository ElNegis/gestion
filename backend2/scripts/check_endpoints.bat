@echo off
setlocal enabledelayedexpansion

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
