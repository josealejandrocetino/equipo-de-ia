# revisar.ps1 - diagnóstico del Equipo de IA en Windows.
# Solo MIRA y reporta. No instala, no descarga, no borra, no modifica nada.

$ErrorActionPreference = "Continue"
$faltan = @()

function Titulo($t) { Write-Host ""; Write-Host $t -ForegroundColor White }
function Ok($q, $d)  { Write-Host ("  OK    {0,-26} {1}" -f $q, $d) -ForegroundColor Green }
function No($q, $d, $c) { Write-Host ("  FALTA {0,-26} {1}" -f $q, $d) -ForegroundColor Red
                          $script:faltan += [pscustomobject]@{Que=$q; Como=$c} }
function Av($q, $d)  { Write-Host ("  AVISO {0,-26} {1}" -f $q, $d) -ForegroundColor Yellow }
function Hay($cmd)   { $null -ne (Get-Command $cmd -ErrorAction SilentlyContinue) }

Write-Host ""
Write-Host "════ REVISIÓN DEL EQUIPO DE IA ════" -ForegroundColor White

# ── La PC ──
Titulo "Tu PC"
$os = Get-CimInstance Win32_OperatingSystem -ErrorAction SilentlyContinue
Write-Host ("  {0,-32} {1}" -f "Windows", $os.Caption)
Write-Host ("  {0,-32} {1}" -f "Arquitectura", $env:PROCESSOR_ARCHITECTURE)

# ── Base ──
Titulo "Lo que hace falta para editar"

if (Hay winget) { Ok "winget" "el instalador de programas" }
else { No "winget" "el instalador de programas" "Actualiza Windows o instala 'Instalador de aplicaciones' desde la Microsoft Store" }

if (Hay ffmpeg) { Ok "ffmpeg" ((ffmpeg -version 2>&1 | Select-Object -First 1) -split ' ' | Select-Object -First 3) -join ' ' }
else { No "ffmpeg" "el motor de video" "Corre instalar-windows.bat" }

$wx = @(
  "$env:USERPROFILE\.equipo-de-ia\wx-env\Scripts\python.exe",
  "$env:USERPROFILE\wx-env\Scripts\python.exe"
) | Where-Object { Test-Path $_ } | Select-Object -First 1

if ($wx) {
  & $wx -c "import whisperx" 2>$null
  if ($LASTEXITCODE -eq 0) { Ok "WhisperX" (Split-Path (Split-Path $wx)) }
  else { No "WhisperX" "el entorno existe pero la librería no carga" "Corre instalar-windows.bat" }
} else { No "WhisperX" "el transcriptor de precisión" "Corre instalar-windows.bat" }

# Ojo: Windows trae un 'python' de mentira que solo abre la Microsoft Store.
# Al pedirle que importe PIL falla, asi que este filtro ya lo descarta solo.
$py = @($wx, (Get-Command python -ErrorAction SilentlyContinue).Source) |
      Where-Object { $_ } | Where-Object { & $_ -c "import PIL" 2>$null; $LASTEXITCODE -eq 0 } |
      Select-Object -First 1
if ($py) { Ok "Pillow" "para los apoyos visuales" }
else { No "Pillow" "dibuja los apoyos visuales" "Corre instalar-windows.bat" }

$chrome = @(
  "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
  "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
  "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe"
) | Where-Object { Test-Path $_ } | Select-Object -First 1
if ($chrome) { Ok "Google Chrome" "todo el texto en pantalla sale de aquí" }
else { No "Google Chrome" "genera los rótulos y subtítulos" "Descárgalo de google.com/chrome" }

if (Hay node) { Ok "Node.js" (node --version) }
else { No "Node.js" "necesario para Claude Code" "Corre instalar-windows.bat" }

if (Hay git) { Ok "Git" "Claude Code lo pide para abrir tu carpeta" }
else { No "Git" "sin esto Claude Code no abre carpetas locales" "Corre instalar-windows.bat" }

if (Hay pdftoppm) { Ok "poppler" "lee PDFs de referencia" }
else { Av "poppler" "no está - solo afecta a leer PDFs de referencia, nada más" }

# ── Claude Code y el plugin ──
Titulo "Claude Code"
if (Hay claude) {
  Ok "Claude Code" (claude --version 2>&1 | Select-Object -First 1)
  if ((claude plugin list 2>&1) -match "equipo-de-ia") { Ok "Plugin Equipo de IA" "instalado" }
  else { No "Plugin Equipo de IA" "el pipeline de edición" "Corre instalar-windows.bat" }
} else {
  No "Comando claude" "no es la app - es el comando que instala el plugin" "Corre instalar-windows.bat"
  Write-Host "        Tener la app de Claude instalada no basta: son dos cosas distintas."
  Write-Host "        La app sigue funcionando igual; esto solo anade el comando."
}

# ── Carpeta de trabajo ──
Titulo "Tu carpeta de trabajo"
$trabajo = $null
$cfg = "$env:USERPROFILE\.equipo-de-ia\config"
if (Test-Path $cfg) {
  $guardada = (Select-String -Path $cfg -Pattern '^TRABAJO=' | Select-Object -First 1) -replace '^.*TRABAJO=', ''
  if ($guardada -and (Test-Path "$guardada\content-os")) { $trabajo = $guardada }
  elseif ($guardada) { Av "carpeta movida" "el instalador la dejó en $guardada y ya no está ahí" }
}
if (-not $trabajo) {
  $trabajo = @([Environment]::GetFolderPath("Desktop"),
               "$env:USERPROFILE\Desktop",
               "$env:USERPROFILE\OneDrive\Escritorio",
               "$env:USERPROFILE\OneDrive\Desktop",
               "$env:USERPROFILE\Documents", "$env:USERPROFILE") | Where-Object { $_ } |
    ForEach-Object { Get-ChildItem $_ -Directory -Filter "*-Cowork" -ErrorAction SilentlyContinue } |
    Where-Object { Test-Path "$($_.FullName)\content-os" } |
    Select-Object -First 1 -ExpandProperty FullName
}
if ($trabajo) {
  Ok "content-os" $trabajo
  $n = (Get-ChildItem "$trabajo\content-os\raw-footage" -ErrorAction SilentlyContinue).Count
  Write-Host ("  {0,-32} {1}" -f "Videos en raw-footage", $n)
} else {
  Av "content-os" "no la encontré en los sitios habituales"
  Write-Host "        No es un error si la tienes en otro lado."
  Write-Host "        Abre Claude Code en tu carpeta de trabajo y ahí funciona."
}

# ── Nivel 3 ──
Titulo "Nivel 3 - Animación (opcional, de pago)"
$ae = Get-ChildItem "$env:ProgramFiles\Adobe" -Directory -Filter "Adobe After Effects*" -ErrorAction SilentlyContinue |
      Sort-Object Name | Select-Object -Last 1
if ($ae) {
  Ok "After Effects" $ae.Name
  $panel = Join-Path $ae.FullName "Support Files\Scripts\ScriptUI Panels\mcp-bridge-auto.jsx"
  if (Test-Path $panel) { Ok "Puente de After Effects" "panel instalado" }
  else { Av "Puente de After Effects" "falta el panel - pídele a Claude que te guíe" }
} else {
  Write-Host ("  -     {0,-26} {1}" -f "After Effects", "no instalado") -ForegroundColor Yellow
  Write-Host "        No hace falta. Los niveles 1 y 2 funcionan sin él."
}

# ── Veredicto ──
function Falta($q) { $script:faltan.Que -contains $q }
Titulo "════ QUÉ PUEDES HACER HOY ════"
# Sin el plugin no se puede editar nada, por muy instalado que este lo demas.
$n1 = -not (Falta "ffmpeg") -and -not (Falta "WhisperX") -and -not (Falta "Git") `
      -and -not (Falta "Comando claude") -and -not (Falta "Plugin Equipo de IA")
$n2 = $n1 -and -not (Falta "Google Chrome") -and -not (Falta "Pillow")
$n3 = $n2 -and $null -ne $ae
function Linea($t, $v) { if ($v) { Write-Host ("  SÍ  " + $t) -ForegroundColor Green }
                         else    { Write-Host ("  NO  " + $t) -ForegroundColor Red } }
Linea "Nivel 1 - Corte: silencios, tomas, subtítulos" $n1
Linea "Nivel 2 - Acabado: rótulos, apoyos, sonidos"   $n2
Linea "Nivel 3 - Animación: motion graphics"          $n3

if ($faltan.Count -gt 0) {
  Titulo "Cómo arreglarlo"
  $faltan | Sort-Object Que -Unique | ForEach-Object { Write-Host ("  {0,-24} {1}" -f $_.Que, $_.Como) }
} else {
  Write-Host ""
  Write-Host "  Todo listo. Abre Claude Code en tu carpeta y escribe `"edita este video`"." -ForegroundColor Green
}

Write-Host ""
Write-Host "════════════════════════════════════" -ForegroundColor White
