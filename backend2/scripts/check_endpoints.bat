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

echo 🎉 Todos los endpoints funcionaron correctamente
exit /b 0
