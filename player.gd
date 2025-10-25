extends CharacterBody3D

# Define la velocidad de movimiento y la fuerza del salto.
# @export hace que la variable aparezca en el Inspector de Godot.
@export var speed = 5.0
@export var jump_velocity = 4.5

# Obtiene la configuración de gravedad del proyecto.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	# ----- 1. GRAVEDAD -----
	# Añade gravedad cada frame si no estamos en el suelo.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# ----- 2. SALTO -----
	# Comprueba si se acaba de presionar la acción "ui_accept" (Barra Espaciadora)
	# y si estamos en el suelo.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# ----- 3. MOVIMIENTO (WASD) -----
	# Input.get_vector obtiene un vector 2D del input (WASD o flechas).
	# "ui_left" y "ui_right" son A/D.
	# "ui_up" y "ui_down" son W/S.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Creamos un vector 3D para la dirección, usando el input_dir.
	# No usamos rotación, así que W (ui_up) se mapea a Z negativo (adelante).
	# 'normalized()' asegura que el vector tenga longitud 1 (para velocidad constante).
	var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()

	# ----- 4. APLICAR VELOCIDAD -----
	# Si hay dirección (se está presionando una tecla)
	if direction:
		# Aplicamos la velocidad en X y Z.
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		# Si no hay input, frenamos al personaje.
		# 'move_toward' mueve un valor hacia otro a una velocidad dada.
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	# ----- 5. MOVER -----
	# ¡La función mágica! Mueve el CharacterBody basado en 'velocity',
	# maneja colisiones, deslizamientos y actualiza is_on_floor().
	move_and_slide()
