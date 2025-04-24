extends CharacterBody3D

# Parámetros de movimiento
var speed = 5.0
var jump_force = 4.5
var gravity = 9.8
var sprint_speed = 10.0
@export var mouse_sensitivity = 0.002

# Referencia al nodo de animación
@onready var animation_controller = $"character-male-b"  # Ajusta esta ruta según tu escena

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	# Gravedad
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Salto
	if Input.is_action_just_pressed("tap_accept") and is_on_floor():
		velocity.y = jump_force
		animation_controller.trigger_jump()
	
	# Movimiento
	var input_dir = Input.get_vector("tap_left", "tap_right", "tap_up", "tap_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var is_sprinting = Input.is_action_pressed("tap_sprint")
	var current_speed = sprint_speed if is_sprinting else speed
	
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
	
	# Actualizar animaciones
	animation_controller.update_movement(velocity, is_on_floor(), is_sprinting)
	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = clamp($Camera3D.rotation.x, -PI/2, PI/2)
