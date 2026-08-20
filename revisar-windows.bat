@echo off
REM revisar-windows.bat - abre el diagnostico. Solo mira, no instala nada.
chcp 65001 >nul
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0windows\revisar.ps1" %*
echo.
pause
