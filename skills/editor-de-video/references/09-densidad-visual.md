# Densidad visual — la regla de los 2 segundos

**Algo tiene que moverse en pantalla cada 2 segundos.** No es opinión: está medido.

## La medición

Detección de cambio de imagen a varios umbrales (`select='gt(scene,N)'`), sobre dos videos de
referencia y sobre un primer montaje con el estilo ya aplicado:

| Umbral | Referencia 1 | Referencia 2 | Primer montaje |
|---|---|---|---|
| **0.28** cambios de plano fuertes | 3.92s | 3.04s | **ninguno** |
| **0.12** cambios de plano | 3.48s | 2.79s | **ninguno** |
| **0.05** cualquier movimiento | 2.24s | 1.59s | 2.90s |
| **0.03** movimiento fino | 1.23s | 0.87s | 1.11s |

**Conclusión: las referencias producen un evento visual cada 1.6–2.2 segundos.**

Y el hallazgo incómodo: el primer montaje **no registra un solo cambio de plano**. El detector
lee 215 segundos como una sola escena. El panel cambia de contenido, pero la
composición general nunca se altera lo suficiente. **Densidad ~2× por debajo de la referencia.**

## Por qué importa

En formato corto la retención no se gana con el argumento, se gana impidiendo que el ojo se
aburra. Un plano estático de 8 segundos —aunque el audio sea buenísimo— es una invitación a
deslizar.

## El modelo por capas

No se trata de meter 100 gráficos. Se trata de **capas de movimiento a distintas frecuencias**,
que sumadas dan un evento cada 2 segundos sin que nada se sienta saturado:

| Capa | Frecuencia | Qué es |
|---|---|---|
| **Captions palabra por palabra** | ~0.4s | Ya resuelto. Es la base continua. |
| **Movimiento sutil permanente** | continuo | Deriva o zoom lentísimo en la ventana del hablante. Nunca quieta. |
| **Evento gráfico** | **cada 2s** | Un dato que entra, una línea que se marca, un ícono, una tarjeta, un número que sube |
| **Cambio de composición** | cada 4-6s | El panel cambia de contenido entero, o se va a pantalla completa |

**La capa que suele faltar es la tercera.** Un título que se queda quieto 9 segundos cuenta como
UN evento, no como nueve. Si un elemento va a estar 8 segundos en pantalla, tiene que hacer algo
durante esos 8 segundos: revelarse por partes, subrayarse, contar hacia arriba, cambiar de foco.

## Reglas prácticas

1. **Ningún elemento estático más de 3 segundos.** Si va a durar más, tiene que evolucionar.
2. **Los textos largos entran por partes**, no de golpe. Una lista de 3 ítems son 3 eventos.
3. **Los números cuentan hacia arriba** en lugar de aparecer hechos.
4. **La ventana del hablante nunca está del todo quieta** — una deriva o zoom de 1-2% muy lento.
5. **Alterna el peso visual:** si un tramo tuvo mucho movimiento, el siguiente respira. Densidad
   constante también cansa; lo que no puede haber es un hueco de 8 segundos sin nada.
6. **Cambia la composición cada 4-6 segundos**, aunque sea sutil: pantalla completa vs dos zonas,
   panel claro vs oscuro, elemento centrado vs desplazado.

## Cómo verificar

Después de renderizar, medir:

```bash
ffmpeg -hide_banner -i VIDEO.mp4 -filter:v "select='gt(scene,0.05)',showinfo" -f null - 2>&1 | grep -c pts_time
```

Dividir la duración entre ese número. **Si da más de 2.5 segundos, el video está muerto** y hay
que agregar capas de movimiento antes de entregarlo.
