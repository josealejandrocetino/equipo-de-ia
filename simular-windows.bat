@echo off
REM simular-windows.bat - ENSAYO. Dice que haria, sin instalar nada.
chcp 65001 >nul
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0windows\instalar.ps1" -Simular
echo.
pause
