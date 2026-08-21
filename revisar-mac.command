#!/bin/bash
# revisar-mac.command — diagnóstico del Equipo de IA.
# Solo MIRA y reporta. No instala, no descarga, no borra, no modifica nada.

cd "$(dirname "$0")" || exit 1

V=$'\033[32m'; R=$'\033[31m'; A=$'\033[33m'; N=$'\033[0m'; B=$'\033[1m'
ok(){ printf "  ${V}OK${N}    %-26s %s\n" "$1" "$2"; }
no(){ printf "  ${R}FALTA${N} %-26s %s\n" "$1" "$2"; FALTAN+=("$1|$3"); }
av(){ printf "  ${A}AVISO${N} %-26s %s\n" "$1" "$2"; }
titulo(){ printf "\n${B}%s${N}\n" "$1"; }

FALTAN=()
printf "\n${B}════ REVISIÓN DEL EQUIPO DE IA ════${N}\n"

# ── La Mac ──
titulo "Tu Mac"
CHIP=$(uname -m)
if [ "$CHIP" = "arm64" ]; then BREW_DIR="/opt/homebrew"; CHIP_TXT="Apple Silicon";
else BREW_DIR="/usr/local"; CHIP_TXT="Intel"; fi
printf "  %-32s %s\n" "Procesador" "$CHIP_TXT"
printf "  %-32s %s\n" "macOS" "$(sw_vers -productVersion 2>/dev/null)"
export PATH="$BREW_DIR/bin:$PATH"

# ── Base ──
titulo "Lo que hace falta para editar"

if command -v brew >/dev/null 2>&1; then ok "Homebrew" "$(brew --version 2>/dev/null | head -1)"
else no "Homebrew" "el instalador de programas" "Corre instalar-mac.command"; fi

if command -v ffmpeg >/dev/null 2>&1; then
  ok "ffmpeg" "$(ffmpeg -version 2>/dev/null | head -1 | cut -d' ' -f1-3)"
  if ffmpeg -hide_banner -filters 2>/dev/null | grep -q ' drawtext '; then
    av "ffmpeg drawtext" "disponible (no hace falta, el texto sale de Chrome)"
  fi
else no "ffmpeg" "el motor de video" "Corre instalar-mac.command"; fi

WX=""
for c in "$HOME/.equipo-de-ia/wx-env/bin/python" "$HOME/wx-env/bin/python"; do
  [ -x "$c" ] && { WX="$c"; break; }
done
if [ -n "$WX" ] && "$WX" -c "import whisperx" >/dev/null 2>&1; then
  ok "WhisperX" "$(dirname "$(dirname "$WX")")"
elif [ -n "$WX" ]; then no "WhisperX" "el entorno existe pero la librería no carga" "Corre instalar-mac.command"
else no "WhisperX" "el transcriptor de precisión" "Corre instalar-mac.command"; fi

PY=""
for c in "$WX" "$(command -v python3.11)" "$(command -v python3)"; do
  [ -n "$c" ] && "$c" -c "import PIL" >/dev/null 2>&1 && { PY="$c"; break; }
done
if [ -n "$PY" ]; then ok "Pillow" "para los apoyos visuales"
else no "Pillow" "dibuja los apoyos visuales" "Corre instalar-mac.command"; fi

if [ -d "/Applications/Google Chrome.app" ]; then ok "Google Chrome" "todo el texto en pantalla sale de aquí"
else no "Google Chrome" "genera los rótulos y subtítulos" "Descárgalo de google.com/chrome"; fi

command -v node >/dev/null 2>&1 && ok "Node.js" "$(node --version)" \
  || no "Node.js" "necesario para Claude Code" "Corre instalar-mac.command"

command -v git >/dev/null 2>&1 && ok "Git" "Claude Code lo pide para abrir tu carpeta" \
  || no "Git" "sin esto Claude Code no abre carpetas locales" "Instala las herramientas de Xcode: xcode-select --install"

command -v pdftoppm >/dev/null 2>&1 && ok "poppler" "lee PDFs de referencia" \
  || no "poppler" "lee PDFs de referencia" "Corre instalar-mac.command"

# ── Claude Code y el plugin ──
titulo "Claude Code"
if command -v claude >/dev/null 2>&1; then
  ok "Claude Code" "$(claude --version 2>/dev/null | head -1)"
  if claude plugin list 2>/dev/null | grep -q "equipo-de-ia"; then ok "Plugin Equipo de IA" "instalado"
  else no "Plugin Equipo de IA" "el pipeline de edición" "Corre instalar-mac.command"; fi
else
  no "Comando claude" "no es la app — es el comando que instala el plugin" "Corre instalar-mac.command"
  printf "        %s\n" "Tener la app de Claude instalada no basta: son dos cosas distintas."
  printf "        %s\n" "La app sigue funcionando igual; esto solo añade el comando."
fi

# ── Carpeta de trabajo ──
titulo "Tu carpeta de trabajo"
ENCONTRADA=""
# 1º la ruta que guardó el instalador; 2º los sitios habituales
CFG="$HOME/.equipo-de-ia/config"
if [ -f "$CFG" ]; then
  GUARDADA=$(grep '^TRABAJO=' "$CFG" 2>/dev/null | cut -d= -f2-)
  [ -n "$GUARDADA" ] && [ -d "$GUARDADA/content-os" ] && ENCONTRADA="$GUARDADA"
  [ -n "$GUARDADA" ] && [ ! -d "$GUARDADA/content-os" ] && \
    av "carpeta movida" "el instalador la dejó en ${GUARDADA/#$HOME/~} y ya no está ahí"
fi
if [ -z "$ENCONTRADA" ]; then
  for d in "$HOME"/*-Cowork "$HOME"/Desktop/*-Cowork "$HOME"/Documents/*-Cowork; do
    [ -d "$d/content-os" ] && { ENCONTRADA="$d"; break; }
  done
fi
if [ -n "$ENCONTRADA" ]; then
  # si la movieron, se guarda la ruta nueva y el aviso no vuelve a salir
  if [ -n "$GUARDADA" ] && [ "$GUARDADA" != "$ENCONTRADA" ]; then
    printf 'TRABAJO=%s\n' "$ENCONTRADA" > "$HOME/.equipo-de-ia/config" 2>/dev/null
  fi
  ok "content-os" "${ENCONTRADA/#$HOME/~}"
  N_VID=$(ls -1 "$ENCONTRADA/content-os/raw-footage" 2>/dev/null | wc -l | tr -d ' ')
  printf "  %-32s %s\n" "Videos en raw-footage" "$N_VID"
else
  av "content-os" "no la encontré en los sitios habituales"
  printf "        %s\n" "No es un error si la tienes en otro lado."
  printf "        %s\n" "Abre Claude Code en tu carpeta de trabajo y ahí funciona."
fi

# ── Nivel 3 ──
titulo "Nivel 3 — Animación (opcional, de pago)"
AE=$(ls -d "/Applications/Adobe After Effects "* 2>/dev/null | tail -1)
if [ -n "$AE" ]; then
  ok "After Effects" "$(basename "$AE")"
  PANEL="$AE/Scripts/ScriptUI Panels/mcp-bridge-auto.jsx"
  [ -f "$PANEL" ] && ok "Puente de After Effects" "panel instalado" \
    || av "Puente de After Effects" "falta el panel — pídele a Claude que te guíe"
else
  printf "  ${A}—${N}     %-26s %s\n" "After Effects" "no instalado"
  printf "        %s\n" "No hace falta. Los niveles 1 y 2 funcionan sin él."
fi

# ── Veredicto ──
falta(){ printf '%s\n' "${FALTAN[@]}" | grep -q "^$1|"; }
titulo "════ QUÉ PUEDES HACER HOY ════"
N1=ok; N2=ok; N3=ok
# Sin el plugin no se puede editar nada, por muy instalado que esté lo demás.
{ falta ffmpeg || falta WhisperX || falta "Comando claude" || falta "Plugin Equipo de IA"; } && N1=no
[ "$N1" = no ] && N2=no
{ falta "Google Chrome" || falta Pillow; } && N2=no
[ -z "$AE" ] && N3=no
[ "$N2" = no ] && N3=no
linea(){ [ "$2" = ok ] && printf "  ${V}SÍ${N}  %s\n" "$1" || printf "  ${R}NO${N}  %s\n" "$1"; }
linea "Nivel 1 — Corte: silencios, tomas, subtítulos" "$N1"
linea "Nivel 2 — Acabado: rótulos, apoyos, sonidos"   "$N2"
linea "Nivel 3 — Animación: motion graphics"          "$N3"

if [ ${#FALTAN[@]} -gt 0 ]; then
  titulo "Cómo arreglarlo"
  printf '%s\n' "${FALTAN[@]}" | awk -F'|' '{printf "  %-24s %s\n", $1, $2}' | sort -u
else
  printf "\n  ${V}${B}Todo listo.${N} Abre Claude Code en tu carpeta y escribe \"edita este video\".\n"
fi

printf "\n${B}════════════════════════════════════${N}\n"
printf "Cierra esta ventana cuando quieras.\n\n"
