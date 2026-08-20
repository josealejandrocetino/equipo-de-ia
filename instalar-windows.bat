@echo off
REM instalar-windows.bat - deja lista la PC para el Equipo de IA.
REM Se puede correr las veces que haga falta.
chcp 65001 >nul
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0windows\instalar.ps1" %*
echo.
pause
