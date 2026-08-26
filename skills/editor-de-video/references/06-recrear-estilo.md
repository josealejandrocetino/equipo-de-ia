# Recrear un estilo desde una referencia

De un link — o de video(s) que la persona sube directamente — a un estilo guardado y
reutilizable. **Esta es la máquina de conseguir estilos** — el motivo por el que la
librería crece sola con el tiempo.

## Camino B: la referencia es un archivo subido, no un link

Cuando adjuntan uno o varios videos y dicen algo como *"estos son estilo `<nombre>`, ayúdame
a crear el estilo en base a esto"* — **no les pidas que los guarden ellos mismos.** Antes
de nada:

1. Guárdalos tú, sin pedir permiso — es trabajo rutinario, directamente en
   `content-os/styles/experimental/`, **sueltos**, sin crear todavía la subcarpeta del
   estilo (esa se crea recién en la Fase 5, cuando ya tenga `dna.md`).
2. Nómbralos `<nombre-estilo>-referencia-1.<ext>`, `-2`, `-3`… en el orden en que los
   subieron. Conserva la extensión original.
3. Si ya existen archivos `<nombre-estilo>-referencia-N.<ext>` de una sesión anterior
   (agregaron más referencias al mismo estilo), sigue numerando desde el siguiente número
   libre — no sobrescribas ni reordenes los que ya están.
4. Avisa en una línea dónde quedaron: *"Guardados en `content-os/styles/experimental/` como
   `<nombre-estilo>-referencia-1.mp4` (y -2, -3…)."*
5. Sigue directo con **El proceso** de abajo, usando esos archivos como material — es
   exactamente el mismo análisis que si hubiera llegado un link, solo que aquí ya tienes el
   video en mano en vez de tener que localizarlo.

Esto reemplaza la vuelta manual de entrar a `content-os` → `styles` → `experimental` y
copiar el archivo con el nombre correcto — la hace el editor, no la persona.

## De dónde salen los estilos

1. **Tutoriales de YouTube** — la fuente más rica. Busca literalmente
   `"<creador> editing style After Effects"` o `"<efecto> tutorial After Effects"`. Un tutorial
   explica el *cómo*, no solo enseña el resultado. Vale muchísimo más que una referencia muda.
2. **Pinterest / Instagram / TikTok** — un clip que gustó. Sin explicación, hay que derivarlo
   mirando.
3. **Packs de plantillas de After Effects** — un pack comprado se puede desarmar: se abre, se
   estudian las curvas y se reconstruyen como plantillas propias re-texteables.

**No hace falta ver el tutorial completo antes de pasarlo.** Basta con confirmar que ese es el
estilo que se quiere.

## El proceso

### 1. Extraer el DNA visual

Con el link o el material en mano, saca:
- **Paleta** — fondos, acentos, contraste.
- **Tipografía** — familia, peso, tracking, mayúsculas o no.
- **Curvas de animación** — ¿rápidas o lentas? ¿con rebote o sin? ¿las salidas son más lentas
  que las entradas?
- **Ritmo de cortes** — cada cuánto corta en la parte hablada, cuándo se relaja.
- **Efectos recurrentes** — glow, VHS, grano, liquid glass, motion blur.
- **Sonido** — qué se escucha en cada movimiento.

Si no puedes ver el video con tus herramientas, **pide 2–3 capturas de los momentos clave** —
o mejor, capturas del *antes y después* de una animación para deducir la curva.

Si el creador dejó **expresiones de After Effects** escritas en el video o la descripción,
cópialas tal cual. Es la forma más fiel de reproducir una curva.

### 2. Construir la v1

Recrea **una sola escena**, no el video entero. La escena más representativa del estilo.
Rápido y sucio: el objetivo es tener algo que mirar, no clavarlo a la primera.

Si esa escena necesita footage específico, **di exactamente qué hay que grabar antes
de construir** (encuadre, obturador, apertura, duración, qué gesto hace).

### 3. Iterar (Fase 4 del SKILL.md)

Feedback vago + capturas marcadas → v2, v3, v4… hasta que apruebe. Normalmente son 4–5 rondas
de un par de minutos cada una. **Es normal que la v1 esté floja.** No es señal de que va mal.

### 4. Guardar el DNA

Cuando apruebe → `content-os/styles/experimental/<nombre>/` con su `dna.md`, su plantilla y su
`referencia.md`. Ver `04-content-os.md`.

**Esto es lo que convierte un video suelto en un activo.** Sin este paso, recrear el mismo
estilo dentro de dos meses cuesta lo mismo que la primera vez.

### 5. Extender el estilo

Con el DNA guardado, ya se puede pedir: *"extiende este estilo a las otras escenas del video"*.
Como el estilo está descrito en texto y no solo en un archivo, se aplica coherentemente a
material que nunca estuvo en la referencia original.

---

## Advertencias

- **Recrear el estilo de alguien no es copiar su video.** Se toman técnicas de animación —
  curvas, ritmo, tratamiento de texto — que es exactamente para lo que existen los tutoriales.
  No se recicla su footage, su marca ni su guión.
- **No todo se puede recrear.** Si un estilo depende de un plugin de pago que no está
  instalado, dilo de una vez en vez de aproximar mal y perder tres rondas de iteración.
- **Un estilo por sesión.** Mezclar dos referencias en un mismo intento produce algo que no se
  parece a ninguna de las dos.
