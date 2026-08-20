# instalar.ps1 - deja lista la PC para el Equipo de IA.
# Se puede correr las veces que haga falta: lo que ya está, no se toca.
# Con -Simular dice qué haría, sin instalar nada.

param([switch]$Simular)

$ErrorActionPreference = "Continue"
$DIR = Split-Path (Split-Path $MyInvocation.MyCommand.Path)

# ⚠️ Al publicar en GitHub, cambiar por "usuario/repositorio".
$ORIGEN_PLUGIN = $DIR

function Paso($t) { Write-Host ""; Write-Host ("▸ " + $t) -ForegroundColor White }
function Ya($t)   { Write-Host ("  ya está   " + $t) -ForegroundColor Green }
function Hago($t) { Write-Host ("  instalo   " + $t) -ForegroundColor Yellow }
function Listo($t){ Write-Host ("  listo     " + $t) -ForegroundColor Green }
function Falla($t){ Write-Host ("  error     " + $t) -ForegroundColor Red }
function Hay($c)  { $null -ne (Get-Command $c -ErrorAction SilentlyContinue) }

# Windows solo ensena los programas nuevos a las ventanas que se abren DESPUES.
# Esta ventana ya estaba abierta, asi que hay que releer el PATH del sistema
# despues de cada instalacion o no vera lo que acaba de instalar.
function RefrescarPath {
  $m = [System.Environment]::GetEnvironmentVariable("Path","Machine")
  $u = [System.Environment]::GetEnvironmentVariable("Path","User")
  $env:Path = (@($m, $u) | Where-Object { $_ }) -join ";"
}

# Windows trae un 'python' de mentira que solo abre la Microsoft Store.
# Solo vale el que responde con su version de verdad.
function PythonReal {
  if (Hay py) {
    $v = & py -3.11 --version 2>&1
    if ("$v" -match "Python 3\.11") { return @("py", @("-3.11")) }
  }
  foreach ($c in @("python", "python3")) {
    if (Hay $c) {
      $v = & $c --version 2>&1
      if ("$v" -match "Python 3\.(1[1-9]|[2-9]\d)") { return @($c, @()) }
    }
  }
  return $null
}

# OJO: el parametro NO se puede llamar $args - en PowerShell es una variable
# reservada del sistema, y el comando se acaba lanzando sin argumentos.
function Corre { param([string]$exe, [string[]]$argumentos = @())
  if ($Simular) { Write-Host ("            (simulado) " + $exe + " " + ($argumentos -join " ")) -ForegroundColor Yellow }
  else {
    & $exe @argumentos
    # Si el programa devuelve error, se dice. Un fallo silencioso parece exito.
    if ($LASTEXITCODE -ne 0 -and $null -ne $LASTEXITCODE) {
      Write-Host ("            no salio bien (codigo " + $LASTEXITCODE + ") - corre la revision al terminar") -ForegroundColor Red
    }
  }
}

Write-Host ""
Write-Host "════ INSTALADOR DEL EQUIPO DE IA ════" -ForegroundColor White
if ($Simular) { Write-Host "MODO SIMULACIÓN - no se instala nada" -ForegroundColor Yellow }
Write-Host ""
Write-Host "Esto prepara tu PC para editar video con IA."
Write-Host "Lo que ya tengas instalado no se toca."
Write-Host "Windows puede pedirte permiso de administrador: es normal."

# ── 0. winget ──
if (-not (Hay winget)) {
  Falla "No encuentro winget, que es el instalador de programas de Windows."
  Write-Host "        Actualiza Windows, o instala 'Instalador de aplicaciones'"
  Write-Host "        desde la Microsoft Store, y vuelve a correr esto."
  exit 1
}

# ── 1. Carpeta de trabajo ──
Paso "1/7 · Tu carpeta de trabajo"
$CFG = "$env:USERPROFILE\.equipo-de-ia"
$cfgFile = "$CFG\config"
if (Test-Path $cfgFile) {
  $TRABAJO = (Select-String -Path $cfgFile -Pattern '^TRABAJO=' | Select-Object -First 1) -replace '^.*TRABAJO=', ''
  Ya $TRABAJO
} else {
  Write-Host ""
  $nombre = Read-Host "  ¿Cómo te llamas? (solo para nombrar tu carpeta)"
  $nombre = ($nombre -replace '[\\/:*?"<>|]', '').Trim()
  if (-not $nombre) { $nombre = "Mi" }
  # OJO: con OneDrive el escritorio que la persona VE puede ser
  # C:\Users\<x>\OneDrive\Escritorio, no C:\Users\<x>\Desktop.
  # GetFolderPath devuelve el de verdad; si fallara, se usa el clasico.
  $escritorio = [Environment]::GetFolderPath("Desktop")
  if (-not $escritorio -or -not (Test-Path $escritorio)) { $escritorio = "$env:USERPROFILE\Desktop" }
  $TRABAJO = Join-Path $escritorio "$nombre-Cowork"
  Hago $TRABAJO
}
foreach ($sub in "raw-footage", "styles", "b-roll") {
  if ($Simular) { Write-Host ("            (simulado) crear " + "$TRABAJO\content-os\$sub") -ForegroundColor Yellow }
  else { New-Item -ItemType Directory -Force -Path "$TRABAJO\content-os\$sub" | Out-Null }
}
if (-not $Simular) {
  New-Item -ItemType Directory -Force -Path $CFG | Out-Null
  "TRABAJO=$TRABAJO" | Set-Content -Path $cfgFile -Encoding UTF8
}
Listo "carpeta lista"

# ── 2-3. Programas ──
Paso "2/7 · El instalador de programas"
Ya ("winget " + (winget --version 2>&1 | Select-Object -First 1))

Paso "3/7 · Los programas de edición"
function InstalaWinget($id, $cmd, $texto) {
  if (Hay $cmd) { Ya ($texto) }
  else { Hago $texto; Corre "winget" @("install","--id",$id,"-e","--silent",
                                       "--accept-package-agreements","--accept-source-agreements") }
}
InstalaWinget "Gyan.FFmpeg"          "ffmpeg" "ffmpeg - corta y monta el video"
if (PythonReal) { Ya "Python 3.11 - el lenguaje del transcriptor" }
else { Hago "Python 3.11 - el lenguaje del transcriptor"
       Corre "winget" @("install","--id","Python.Python.3.11","-e","--silent",
                        "--accept-package-agreements","--accept-source-agreements") }
InstalaWinget "OpenJS.NodeJS"        "node"   "Node.js - motor de Claude Code"
# Claude Code necesita Git para trabajar en carpetas locales. macOS ya lo trae; Windows no.
InstalaWinget "Git.Git"              "git"    "Git - lo pide Claude Code para abrir tu carpeta"

$chrome = @("$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
            "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
            "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe") |
          Where-Object { Test-Path $_ } | Select-Object -First 1
if ($chrome) { Ya "Google Chrome - genera el texto en pantalla" }
else { Hago "Google Chrome - genera el texto en pantalla"
       Corre "winget" @("install","--id","Google.Chrome","-e","--silent",
                        "--accept-package-agreements","--accept-source-agreements") }

RefrescarPath   # para que esta misma ventana vea ffmpeg, Python y Node recien instalados

# poppler es opcional: solo sirve para leer PDFs de referencia
if (Hay pdftoppm) { Ya "poppler - lee PDFs de referencia" }
else { Hago "poppler - opcional, si falla no pasa nada"
       Corre "winget" @("install","--id","oschwartz10612.Poppler","-e","--silent",
                        "--accept-package-agreements","--accept-source-agreements") }

# ── 4. WhisperX ──
Paso "4/7 · WhisperX (marca el milisegundo de cada palabra)"
$WXDIR = "$CFG\wx-env"
$wxpy  = "$WXDIR\Scripts\python.exe"
$wxok = $false
if (Test-Path $wxpy) { & $wxpy -c "import whisperx" 2>$null; $wxok = ($LASTEXITCODE -eq 0) }
if ($wxok) { Ya "WhisperX" }
else {
  Hago "WhisperX - es el paso más lento, puede tardar varios minutos"
  $pr = PythonReal
  if ($pr) { Corre $pr[0] ($pr[1] + @("-m","venv",$WXDIR)) }
  elseif ($Simular) { Corre "python" @("-m","venv",$WXDIR) }
  else { Falla "No encuentro un Python 3.11 real. Cierra esta ventana y vuelve a correr el instalador." }
  # pip no puede reemplazarse a si mismo si se le llama por su .exe: hay que
  # pasar por python -m pip. Da error 1 y no es grave, pero ensucia la pantalla.
  Corre "$WXDIR\Scripts\python.exe" @("-m","pip","install","--quiet","--upgrade","pip")
  Corre "$WXDIR\Scripts\python.exe" @("-m","pip","install","--quiet","whisperx==3.8.6","pillow")
}

# ── 5. Claude Code ──
Paso "5/7 · Claude Code"
RefrescarPath
if (Hay claude) { Ya ("Comando claude " + (claude --version 2>&1 | Select-Object -First 1)) }
else {
  Hago "el comando claude (aunque ya tengas la app, el comando va aparte)"
  # npm recien instalado puede no estar todavia en el PATH de esta ventana
  $npm = "npm"
  if (-not (Hay npm)) {
    $c = "$env:ProgramFiles\nodejs\npm.cmd"
    if (Test-Path $c) { $npm = $c } else { Falla "No encuentro npm. Cierra esta ventana y vuelve a correr el instalador." }
  }
  if ($npm) { Corre $npm @("install","-g","@anthropic-ai/claude-code") }
  RefrescarPath
}

# ── 6. El plugin ──
Paso "6/7 · El plugin Equipo de IA"
RefrescarPath
if (-not (Hay claude)) {
  # npm -g deja los comandos aqui; el PATH puede tardar en enterarse
  $cc = "$env:APPDATA\npm\claude.cmd"
  if (Test-Path $cc) { $env:Path = "$env:APPDATA\npm;" + $env:Path }
}
$tieneClaude = Hay claude
if ($tieneClaude -or $Simular) {
  # Solo se le pregunta a claude si claude existe de verdad.
  $yaInstalado = $false
  if ($tieneClaude) { $yaInstalado = ((claude plugin list 2>&1) -match "equipo-de-ia") }
  if ($yaInstalado) {
    Ya "plugin instalado - busco actualizaciones"
    Corre "claude" @("plugin","marketplace","update","equipo-de-ia")
    Corre "claude" @("plugin","update","equipo-de-ia@equipo-de-ia")
  } else {
    Hago "plugin del pipeline de edicion"
    Corre "claude" @("plugin","marketplace","add",$ORIGEN_PLUGIN)
    Corre "claude" @("plugin","install","equipo-de-ia@equipo-de-ia","--yes")
  }
} else { Falla "Claude Code no quedo instalado; el plugin no se pudo poner" }

# ── 7. Revisión ──
Paso "7/7 · Revisión final"
$rev = Join-Path (Split-Path $MyInvocation.MyCommand.Path) "revisar.ps1"
if ((Test-Path $rev) -and (-not $Simular)) { & $rev }
else { Write-Host "  Corre revisar-windows.bat cuando quieras ver cómo quedó todo." }

Write-Host ""
Write-Host ""
Write-Host "  Si arriba viste algo en rojo: cierra esta ventana y vuelve a hacer doble clic" -ForegroundColor Yellow
Write-Host "  en instalar-windows.bat. Windows a veces necesita una ventana nueva para ver"
Write-Host "  los programas recien instalados. Correrlo dos veces no rompe nada."
Write-Host ""
Write-Host "════ CÓMO EMPEZAR ════" -ForegroundColor White
Write-Host "  1. Abre la app de Claude Code"
Write-Host ("  2. Elige la carpeta " + (Split-Path $TRABAJO -Leaf))
Write-Host "  3. Escribe: edita este video"
Write-Host ""
Write-Host "  ⚠️  No le cambies el nombre a esa carpeta ni la muevas de sitio." -ForegroundColor Yellow
Write-Host "      Tu trabajo seguiría funcionando, pero la revisión dejaría de encontrarla."
Write-Host ""
Write-Host "  ¿Quieres motion graphics? Necesitas After Effects (de pago, aparte)."
Write-Host "  Cuando lo tengas, escríbele a Claude: `"quiero instalar After Effects, guíame`"."
Write-Host ""

# ⚠️ SIN PROBAR EN UNA MÁQUINA WINDOWS REAL. Ver README antes de distribuirlo.
