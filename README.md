# Equipo de IA — el Editor

**Tu editor de video, instalado en tu computadora.** Le das el archivo crudo y te devuelve el
video terminado: sin silencios, con las tomas buenas, subtítulos, rótulos, apoyos visuales y
sonido.

Tú solo grabas.

---

## Antes de empezar: lo que cuesta aparte

Este sistema funciona sobre **Claude Code**, que necesita una suscripción a Claude.
**Ese pago va por tu cuenta y no está incluido aquí.** Prefiero decírtelo antes que después:

| Plan | Para qué alcanza |
|---|---|
| **Pro — $20/mes** | **Uno o dos videos al día.** Es el que necesita la mayoría |
| Max | Solo si vas a producir en volumen |

Con el plan Pro tienes de sobra para el uso normal. El Max solo hace falta si vas a editar
mucho más que eso.

---

## Descarga

| | |
|---|---|
| 🍎 **Mac** | Descomprime el `.zip` → doble clic en **`instalar-mac.command`** |
| 🪟 **Windows** | Descomprime el `.zip` → doble clic en **`instalar-windows.bat`** |

El instalador te pregunta tu nombre, deja todo listo y crea tu carpeta de trabajo.
**Puedes correrlo las veces que quieras: lo que ya está instalado no se toca.**

> 🪟 **Windows:** probado de punta a punta en Windows 11. Es normal que Windows te pida permiso
> varias veces y que te avise de que no puede comprobar el editor del archivo — más abajo te
> explico qué hacer con cada aviso.

---

## 🪟 Si estás en Windows, lee esto antes

Windows desconfía de cualquier instalador que no venga de su tienda. **No es que el archivo esté
mal** — le pasa a todos. Esto es lo que vas a ver:

**1. Antes de descomprimir:** clic derecho sobre el `.zip` → **Propiedades** → marca la casilla
**"Desbloquear"** → Aceptar. Con eso te ahorras el aviso siguiente.

**2. Si aun así sale "Windows protegió su PC"** → *Más información* → *Ejecutar de todas formas*.

**3. ⛔ Lo más importante: las ventanas de permiso salen DETRÁS.**

Durante la instalación, Windows te va a preguntar varias veces *"¿Quieres permitir que esta
aplicación haga cambios?"*. **Esas ventanas aparecen escondidas tras la ventana negra**, y hasta
que no respondas, la instalación **se queda parada sin decir nada**.

> Si parece congelado, **mira la barra de tareas**: hay un permiso esperándote.

Son instaladores oficiales — verás nombres como *Python Software Foundation* u *OpenJS
Foundation*. Dale a **Sí**.

**4. Si al final ves algo en rojo:** cierra la ventana y vuelve a hacer doble clic en el
instalador. Windows a veces necesita una ventana nueva para ver los programas recién instalados.
**Correrlo dos veces no rompe nada.**

---

## Qué puedes hacer, según lo que tengas

| Nivel | Qué te entrega | Qué necesitas |
|---|---|---|
| **1 · Corte** | Silencios fuera, tomas elegidas, subtítulos | Solo el instalador |
| **2 · Acabado** | Rótulos, apoyos visuales, sonidos | Solo el instalador |
| **3 · Animación** | Motion graphics | After Effects (de pago, aparte) |

**Los niveles 1 y 2 no necesitan Adobe**, y ahí está la mayor parte del trabajo. El nivel 3 es
una mejora, no un requisito: si no tienes After Effects, el editor **no se detiene** — cambia
de camino y te entrega el video igual.

El estilo que viene incluido está hecho para el nivel 2, así que **funciona sin Adobe desde el
primer día**.

---

## Cómo se usa

1. Descomprime el `.zip`.
2. **Doble clic en el instalador** de tu sistema. Te pregunta tu nombre y prepara la máquina.
3. **Abre la app de Claude Code y elige la carpeta que te creó.** No necesitas la terminal.
4. Mete tu video en `content-os/raw-footage/` y escribe:

> **"edita este video"**

⚠️ **No le cambies el nombre a esa carpeta ni la muevas de sitio** después de instalar.

---

## Si algo no funciona

**Doble clic en `revisar-mac.command`** (o `revisar-windows.bat`). Solo mira: no instala ni
borra nada. Te dice qué falta, cómo arreglarlo, y termina con lo único que importa:

```
════ QUÉ PUEDES HACER HOY ════
  SÍ  Nivel 1 — Corte: silencios, tomas, subtítulos
  SÍ  Nivel 2 — Acabado: rótulos, apoyos, sonidos
  NO  Nivel 3 — Animación: motion graphics
```

Un **NO** en el nivel 3 no es un error: significa que no tienes After Effects, que es opcional.

Si con eso no se arregla, mándame una captura de esa pantalla completa. Dice tu procesador, tu
versión del sistema y qué encontró de cada pieza — con eso se diagnostica sin adivinar.

---

## ¿Quieres motion graphics?

After Effects se compra aparte, en Adobe. **Este instalador no lo instala.**

Cuando lo tengas, escríbele a Claude:

> **"quiero instalar After Effects, guíame"**

Y te lleva paso a paso hasta dejarlo conectado. Si no lo vas a comprar, no te aparece nunca —
no hay ningún paso trabado esperándote.

---

## Los estilos

Un **estilo** es una receta de edición: el ritmo, la tipografía, cómo entra el texto, dónde van
los apoyos, qué suena y cuándo.

- **Los que vienen incluidos** se actualizan solos. Cada vez que sale uno nuevo, te llega.
- **Los que hagas tú** viven en tu `content-os/styles/` y **nunca se tocan.** Tu trabajo es tuyo.

Si quieres partir de un estilo incluido y cambiarlo, cópialo primero a tu carpeta. Si lo editas
en su sitio, la siguiente actualización se lo lleva.

---

## Lo que hace falta

- **Mac o Windows 10/11**
- **Suscripción a Claude** — Pro ($20/mes) alcanza para uno o dos videos al día. **Va aparte**
- **Google Chrome** — no es opcional: de ahí sale todo el texto en pantalla
- Unos 5 GB libres entre programas y modelos
- *(Opcional)* After Effects, solo para el nivel 3

---

## Actualizaciones

Se actualiza solo desde este repositorio. Cuando arreglo algo o sale un estilo nuevo, te llega
sin que tengas que descargar nada otra vez.

Para quitarlo:

```bash
claude plugin uninstall equipo-de-ia@equipo-de-ia
claude plugin marketplace remove equipo-de-ia
```

Tu carpeta de trabajo y tus videos **no se borran**.

---

## Preguntas frecuentes

**¿Es peligroso instalar todo esto?**
No. Todo entra por canales oficiales: en Windows por **winget**, que es de Microsoft, y en Mac por
**Homebrew**. Python viene de python.org, Node de la OpenJS Foundation, Chrome de Google y Claude
Code de Anthropic. Son herramientas que usan millones de personas todos los días.

**¿Se queda algo corriendo en segundo plano?**
No. No se instala ningún servicio, nada arranca con el sistema y nada se conecta por su cuenta.

**¿Cómo lo desinstalo?**
Los programas se quitan con el gestor de tu sistema, y el transcriptor vive aislado en una sola
carpeta (`.equipo-de-ia`): la borras y no queda rastro. Tus videos no se tocan.

**¿Cuánto ocupa?**
Unos 5 GB entre programas y modelos. La mayor parte es el transcriptor.

**¿Y el puente de After Effects?**
Ese sí es un proyecto de la comunidad, no de una empresa grande, y pide permisos de administrador.
Por eso **no lo instala el instalador** y solo se monta si tú lo pides. Los niveles 1 y 2 no lo
tocan.

**¿Tengo que saber usar la terminal?**
No. Se hace todo con doble clic, y después trabajas dentro de la app de Claude Code escribiendo
en español.

---

## Límites, dichos de frente

- **Formato vertical 9:16.** El horizontal para YouTube todavía no está probado de punta a punta.
- **No elige música de catálogo.** La música se sintetiza y se cuadra con tus cortes; no se
  descarga ni se extrae de ningún sitio.
- **La corrección de color está fuera de alcance.**
- **Esto no inventa un estilo por ti.** Reproduce y ejecuta uno que viene de una referencia.
  Sin referencia, el resultado es genérico.

---

## Licencia

Uso personal y para tus clientes. **No se puede revender ni redistribuir.** Ver [LICENSE](LICENSE).
