# Practica-04---Mi-primera-escena-3D-interactiva-en-Godot-4.x
Objetivo

Crear una escena 3D jugable con piso, luz, cámara y un personaje básico que se mueva con teclado y que puedas exportar a una build local.

Problemas Encontrados y Resolución

Durante el desarrollo, el principal desafío fue lograr que el personaje colisionara correctamente con el piso. El personaje "flotaba" en el aire y no aterrizaba.

La depuración reveló múltiples problemas que fueron solucionados paso a paso:

Problema de Física del Piso: El piso (Floor) era inicialmente un Node3D, el cual no tiene propiedades físicas.
Solución: Se reemplazó el Node3D raíz del piso por un StaticBody3D (Floor_fisico) para que pudiera interactuar con el motor de física.

Error de Jerarquía: Las paredes (Wall_N, Wall_S, etc.) estaban como hijas de un Node3D separado, lo que causaba un error de física al ser "colisiones huérfanas".
Solución: Se movieron todas las CollisionShape3D (piso y paredes) para que fueran hijas directas del único StaticBody3D (Floor_fisico).

Error de Scale vs. Size: El CollisionShape3D del piso tenía una Scale (Escala) de (20,1,20), lo cual rompe el motor de física.
Solución: Se reestableció la Scale a (1,1,1) y se ajustó la propiedad Shape -> Size (Tamaño) del BoxShape3D a (20,1,20).

Error de Asignación de Script: El nodo Player (tanto en player.tscn como en main.tscn) tenía asignado el archivo de escena (player.tscn) en su propiedad Script en lugar del archivo de código (player.gd).
Solución: Se reasignó el script correcto (player.gd) a la propiedad Script del nodo Player en ambas escenas.

Problema Visual (El Bug Final): Una vez que la física funcionaba, el personaje visualmente seguía flotando.
Solución: Se descubrió que el CollisionShape3D del jugador estaba en Position y=1, pero su MeshInstance3D (el modelo visual) estaba en Position y=2. Esto hacía que el modelo visual estuviera 1 metro por encima de su colisión. Se alinearon ambos nodos a Position y=1 para sincronizar lo físico con lo visual.
