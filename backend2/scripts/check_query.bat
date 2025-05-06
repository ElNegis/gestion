@echo off
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
