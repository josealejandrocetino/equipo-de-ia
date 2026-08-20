#!/bin/bash
# instalar-mac.command — deja lista la Mac para el Equipo de IA.
# Se puede correr las veces que haga falta: lo que ya está, no se toca.
# Con --simular dice qué haría, sin instalar nada.

cd "$(dirname "$0")" || exit 1
DIR="$(pwd)"

# ⚠️ Al publicar en GitHub, cambiar por "usuario/repositorio".
ORIGEN_PLUGIN="$DIR"

SIMULAR=false
[ "$1" = "--simular" ] && SIMULAR=true

V=$'\033[32m'; R=$'\033[31m'; A=$'\033[33m'; N=$'\033[0m'; B=$'\033[1m'
paso(){ printf "\n${B}▸ %s${N}\n" "$1"; }
ya(){   printf "  ${V}ya está${N}   %s\n" "$1"; }
hago(){ printf "  ${A}instalo${N}   %s\n" "$1"; }
listo(){ printf "  ${V}listo${N}     %s\n" "$1"; }
error(){ printf "  ${R}error${N}     %s\n" "$1"; }

corre(){ if $SIMULAR; then printf "            ${A}(simulado)${N} %s\n" "$*"; else "$@"; fi; }

printf "\n${B}════ INSTALADOR DEL EQUIPO DE IA ════${N}\n"
$SIMULAR && printf "${A}MODO SIMULACIÓN — no se instala nada${N}\n"
printf "\nEsto prepara tu Mac para editar video con IA.\n"
printf "Lo que ya tengas instalado no se toca.\n"
printf "En algún momento te va a pedir la contraseña de tu Mac: es normal,\n"
printf "la piden los instaladores de Apple para escribir en carpetas del sistema.\n"

# ── El chip ──
if [ "$(uname -m)" = "arm64" ]; then BREW_DIR="/opt/homebrew"; else BREW_DIR="/usr/local"; fi
export PATH="$BREW_DIR/bin:$PATH"

# ── 1. Nombre y carpeta de trabajo ──
paso "1/7 · Tu carpeta de trabajo"
CFG="$HOME/.equipo-de-ia"
if [ -f "$CFG/config" ] && grep -q '^TRABAJO=' "$CFG/config" 2>/dev/null; then
  TRABAJO=$(grep '^TRABAJO=' "$CFG/config" | cut -d= -f2-)
  ya "${TRABAJO/#$HOME/~}"
else
  printf "\n  ¿Cómo te llamas? (solo para nombrar tu carpeta)\n  > "
  read -r NOMBRE
  NOMBRE=$(echo "$NOMBRE" | tr -d '/:\\' | sed 's/^ *//; s/ *$//')
  [ -z "$NOMBRE" ] && NOMBRE="Mi"
  TRABAJO="$HOME/Desktop/${NOMBRE}-Cowork"
  hago "${TRABAJO/#$HOME/~}"
fi
corre mkdir -p "$TRABAJO/content-os/raw-footage" "$TRABAJO/content-os/styles" "$TRABAJO/content-os/b-roll"
corre mkdir -p "$CFG"
$SIMULAR || { printf 'TRABAJO=%s\n' "$TRABAJO" > "$CFG/config"; }
listo "carpeta lista"

# ── 2. Homebrew ──
paso "2/7 · Homebrew (el instalador de programas)"
if command -v brew >/dev/null 2>&1; then ya "$(brew --version | head -1)"
else
  hago "Homebrew — tarda unos minutos y pide tu contraseña"
  corre /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$("$BREW_DIR/bin/brew" shellenv 2>/dev/null)" 2>/dev/null
  PERFIL="$HOME/.zprofile"
  if ! grep -q 'brew shellenv' "$PERFIL" 2>/dev/null; then
    $SIMULAR || echo "eval \"\$($BREW_DIR/bin/brew shellenv)\"" >> "$PERFIL"
  fi
fi

# ── 3. Programas de Homebrew ──
paso "3/7 · Los programas de edición"
instala_brew(){ # $1 fórmula  $2 comando que la comprueba  $3 explicación
  if command -v "$2" >/dev/null 2>&1; then ya "$1 — $3"
  else hago "$1 — $3"; corre brew install "$1"; fi
}
instala_brew ffmpeg      ffmpeg    "corta y monta el video"
instala_brew python@3.11 python3.11 "el lenguaje del transcriptor"
instala_brew node        node      "motor de Claude Code"
instala_brew poppler     pdftoppm  "lee PDFs de referencia"

if [ -d "/Applications/Google Chrome.app" ]; then ya "Google Chrome — genera el texto en pantalla"
else hago "Google Chrome — genera el texto en pantalla"; corre brew install --cask google-chrome; fi

# ── 4. WhisperX ──
paso "4/7 · WhisperX (marca el milisegundo de cada palabra)"
WXDIR="$CFG/wx-env"
if [ -x "$WXDIR/bin/python" ] && "$WXDIR/bin/python" -c "import whisperx" >/dev/null 2>&1; then
  ya "WhisperX"
else
  hago "WhisperX — es el paso más lento, puede tardar varios minutos"
  corre python3.11 -m venv "$WXDIR"
  # siempre python -m pip, nunca el pip suelto: así pip puede actualizarse a sí mismo
  corre "$WXDIR/bin/python" -m pip install --quiet --upgrade pip
  corre "$WXDIR/bin/python" -m pip install --quiet "whisperx==3.8.6" pillow
fi

# ── 5. Claude Code ──
paso "5/7 · Claude Code"
if command -v claude >/dev/null 2>&1; then ya "Comando claude $(claude --version 2>/dev/null | head -1)"
else hago "el comando claude (aunque ya tengas la app, el comando va aparte)"
     corre npm install -g @anthropic-ai/claude-code; fi

# ── 6. El plugin ──
paso "6/7 · El plugin Equipo de IA"
if command -v claude >/dev/null 2>&1 || $SIMULAR; then
  if claude plugin list 2>/dev/null | grep -q "equipo-de-ia"; then
    ya "plugin instalado — busco actualizaciones"
    corre claude plugin marketplace update equipo-de-ia
    corre claude plugin update equipo-de-ia@equipo-de-ia
  else
    hago "plugin del pipeline de edición"
    corre claude plugin marketplace add "$ORIGEN_PLUGIN"
    corre claude plugin install equipo-de-ia@equipo-de-ia --yes
  fi
else error "Claude Code no quedó instalado; el plugin no se pudo poner"; fi

# ── 7. Revisión ──
paso "7/7 · Revisión final"
if [ -x "$DIR/revisar-mac.command" ] && ! $SIMULAR; then
  "$DIR/revisar-mac.command"
else
  printf "  Corre revisar-mac.command cuando quieras ver cómo quedó todo.\n"
fi

printf "\n${B}════ CÓMO EMPEZAR ════${N}\n"
printf "  1. Abre la app de Claude Code\n"
printf "  2. Elige la carpeta ${B}%s${N}\n" "$(basename "$TRABAJO")"
printf "  3. Escribe: ${B}edita este video${N}\n"
printf "\n  ${A}⚠️  No le cambies el nombre a esa carpeta ni la muevas de sitio.${N}\n"
printf "      Tu trabajo seguiría funcionando, pero la revisión dejaría de encontrarla.\n"
printf "\n  ¿Quieres motion graphics? Necesitas After Effects (de pago, aparte).\n"
printf "  Cuando lo tengas, escríbele a Claude: \"quiero instalar After Effects, guíame\".\n\n"
