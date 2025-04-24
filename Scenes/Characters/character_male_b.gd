extends Node3D

@onready var ani = $AnimationTree

enum {IDLE, RUN, JUMP}
var current_anim = IDLE
var blend_speed = 15.0

# Variables de control
var run_val = 0.0
var jump_val = 0.0

func update_movement(velocity: Vector3, is_on_floor: bool, is_sprinting: bool):
	# Determinar el estado actual
	if not is_on_floor:
		current_anim = JUMP
	elif Vector2(velocity.x, velocity.z).length() > 0.1:
		current_anim = RUN
	else:
		current_anim = IDLE
	
	# Actualizar valores de blend
	match current_anim:
		IDLE:
			run_val = lerpf(run_val, 0.0, blend_speed * get_physics_process_delta_time())
			jump_val = lerpf(jump_val, 0.0, blend_speed * get_physics_process_delta_time())
		RUN:
			run_val = lerpf(run_val, 1.0, blend_speed * get_physics_process_delta_time())
			jump_val = lerpf(jump_val, 0.0, blend_speed * get_physics_process_delta_time())
		JUMP:
			run_val = lerpf(run_val, 0.0, blend_speed * get_physics_process_delta_time())
			jump_val = lerpf(jump_val, 1.0, blend_speed * get_physics_process_delta_time())
	
	# Aplicar al AnimationTree
	ani["parameters/Run/add_amount"] = run_val
	ani["parameters/Jump/add_amount"] = jump_val

func trigger_jump():
	# Forzar inmediatamente la animación de salto
	jump_val = 1.0
	ani["parameters/Jump/add_amount"] = jump_val
