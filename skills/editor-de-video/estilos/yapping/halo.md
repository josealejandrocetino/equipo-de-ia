# El halo del estilo yapping — la especificación

> Fijada sobre un video de referencia con el rótulo
> *"guess how many people signed up?"* en blanco sobre un techo gris claro.
> Sus palabras: **«se ve alrededor el halo, la sombra detrás, pero superdifuminada,
> o sea, no se ve como un cuadrado que lo cubre, así es como quiero que se vea»**.

⚠️ **La imagen original está en el chat del 2026-08-15, no en disco.** No puedo escribir
en disco una imagen pegada en la conversación. `halo-referencia-repro.jpg` (aquí al lado)
es la **reproducción** con los valores de abajo, sobre el mismo gris claro y con el mismo
texto, para poder comparar de un vistazo. Si querés el archivo original, arrastralo a
esta carpeta como `halo-referencia.jpg`.

---

## ⛔ El `text-shadow` de CSS NO sirve para esto

Es la causa del "cuadrado de sombra" que se rechazó **dos veces** (en los
rótulos, 2026-08-15 en el titular de yapping). Tres sombras apiladas de radio grande a
41-47% cada una:

- se suman a ~76% de negro pegado a las letras,
- y su caída **no es gaussiana**: tiene una meseta y después un escalón.

Sobre un fondo liso y claro ese escalón se lee como el borde de un bloque rectangular.
**No es que el PNG esté recortado** — es la forma de la sombra. En el video del
2026-08-19 medí los cuatro bordes del archivo y estaban en alfa 0; el cuadrado seguía ahí.

## ✅ Cómo se construye

Chrome escribe las letras **sin ninguna sombra**. El halo se hace después, sobre el canal
alfa de las propias letras:

```
SIGMAS_REL = ((0.1125, 0.55), (0.375, 0.42))   # (σ / cuerpo de letra, opacidad)
```

A 80 px de cuerpo eso es **σ9 al 55% + σ30 al 42%**, en píxeles de pantalla final.

Los cuatro detalles que lo hacen funcionar:

1. **σ en proporción al cuerpo de letra, no en píxeles fijos.** Con sigmas fijas, el halo
   de un caption de 60 px sale relativamente 1.3 veces más ancho que el del titular de
   80 px y dejan de parecer del mismo estilo.
2. **El lienzo se agranda 5σ por lado ANTES de desenfocar.** Si desenfocás sobre un
   lienzo justo, el desenfoque se corta contra el borde y vuelve el cuadrado.
3. **Se acumulan como capas, no se suman:** `halo = halo + (1-halo) * capa`. Sumar
   satura y devuelve la meseta.
4. **Comprobar que los cuatro bordes del PNG quedan en alfa 0 exacto.**

## Los tres anchos que se probaron

| σ (a 80 px) | Resultado |
|---|---|
| σ4 op0.50 + σ12 op0.30 | arregla el cuadrado pero **apenas se ve** — rechazado |
| σ7 op0.55 + σ22 op0.38 | cerca |
| **σ9 op0.55 + σ30 op0.42** | **el que reproduce la referencia** ✅ |

## Fuerza por elemento

| Elemento | Multiplicador |
|---|---|
| Titular | 1.00 |
| Captions | **1.15** — van sobre la cara y la ropa, no sobre pared lisa |

## Dónde está el código

`content-os/raw-footage/2026-08-19/scripts/textos.py` → `poner_halo()`.
Es el original; copiarlo de ahí para el siguiente video.
