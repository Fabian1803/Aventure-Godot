extends CharacterBody3D

# Parámetros de movimiento
@export var speed := 5.0
@export var jump_force := 4.5
@export var gravity := 9.8
@export var sprint_speed := 10.0
@export var mouse_sensitivity := 0.002
var is_sprintingM := false

# Referencias a nodos
@onready var model = $"character-male-b"
@onready var pivot = $Pivot
@onready var cam = $Pivot/Camera3D
@onready var animation_controller = $"character-male-b"  # Asegúrate de que tu nodo tiene los métodos esperados
@onready var joystick = $tabs/Joistick

#Life
var vida_actual: int = 3 
var esta_muerto: bool = false
var picked_object
var pull_power = 4

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	print("Vidas iniciales: ", vida_actual)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		# Rotación horizontal del pivot
		pivot.rotate_y(-event.relative.x * mouse_sensitivity)

		# Rotación vertical de la cámara (solo en X)
		var new_x = clamp(cam.rotation.x - event.relative.y * mouse_sensitivity, deg_to_rad(-80), deg_to_rad(80))
		cam.rotation.x = new_x

func _physics_process(delta):
	# Aplicar gravedad
	if not is_on_floor():
		velocity.y -= gravity * delta
	if esta_muerto:
		velocity.x = 0
		velocity.z = 0
		move_and_slide()  # Para que la gravedad actúe (cae al piso si está en el aire)
		return  # ¡Y salimos del proceso!
	# Dirección del movimiento
	var input_dir = joystick.get_direccion()
	var direction = Vector3.ZERO
	var is_sprinting = is_sprintingM
	var current_speed = sprint_speed if is_sprinting else speed

	if input_dir != Vector2.ZERO:
		# Dirección según la cámara (PIVOT)
		var cam_basis = pivot.global_transform.basis
		var forward = cam_basis.z.normalized() * 1  # Asegúrate que esta dirección es correcta para TU modelo
		var right = cam_basis.x.normalized()
		direction = (right * input_dir.x + forward * input_dir.y).normalized()

		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
		

		# Rotar el modelo para que mire hacia el movimiento
		var look_dir = -Vector3(direction.x, 0, direction.z)
		if look_dir.length() > 0.1:
			model.look_at(global_transform.origin + look_dir, Vector3.UP)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		
	##Agarrar

	# SALTO
	if Input.is_action_just_pressed("tap_accept") and is_on_floor():
		velocity.y = jump_force
		if animation_controller.has_method("trigger_jump"):
			animation_controller.trigger_jump()

	# Animaciones de movimiento
	if animation_controller.has_method("update_movement"):
		animation_controller.update_movement(velocity, is_on_floor(), is_sprinting)

	# Movimiento físico
	move_and_slide()
	
func curar(cantidad: int):
	vida_actual += cantidad
	print("Vidas actuales: ", vida_actual)
	# actualizar_ui_vidas()  # Si tienes UI, descomenta esta línea

func recibir_danio(cantidad: int):
	vida_actual -= cantidad
	print("¡Has recibido daño! Vidas restantes: ", vida_actual)
	
	if vida_actual <= 0:
		print("GAME OVER: Reiniciando partida completa")
		get_tree().reload_current_scene()  # Reinicia el nivel completo
		vida_actual = 3  # Reinicia las vidas (o podrías guardar este valor en otro sistema)
	else:
		esta_muerto = true
		print("Reiniciando con una vida menos...")
		animation_controller.trigger_death()
		await get_tree().create_timer(1.2).timeout
		get_tree().reload_current_scene()


func _on_button_jump_pressed() -> void:
	if is_on_floor():
		velocity.y = jump_force
		if animation_controller.has_method("trigger_jump"):
			animation_controller.trigger_jump()

func _on_button_sprint_toggled(toggled_on: bool) -> void:
	is_sprintingM = toggled_on


func _on_button_stop_pressed() -> void:
	pass # Replace with function body.
