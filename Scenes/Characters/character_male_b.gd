extends Node3D

@onready var ani = $AnimationTree

enum {IDLE, WALK, RUN, JUMP, FALL, DIE}
var current_anim = IDLE
var blend_speed = 15.0

# Variables de control
var walk_val = 0.0
var run_val = 0.0
var jump_val = 0.0
var fall_val = 0.0
var die_val = 0.0

func update_movement(velocity: Vector3, is_on_floor: bool, is_sprinting: bool):
	if current_anim == DIE:
		return  # No actualices movimiento si está muert
	# Determinar el estado actual
	if not is_on_floor:
		current_anim = FALL if velocity.y < 0 else JUMP
	elif Vector2(velocity.x, velocity.z).length() > 0.1:
		current_anim = RUN if is_sprinting else WALK
	else:
		current_anim = IDLE
	
	# Actualizar valores de blend
	match current_anim:
		IDLE:
			walk_val = lerpf(walk_val, 0.0, blend_speed * get_physics_process_delta_time())
			run_val = lerpf(run_val, 0.0, blend_speed * get_physics_process_delta_time())
			jump_val = lerpf(jump_val, 0.0, blend_speed * get_physics_process_delta_time())
			fall_val = lerpf(fall_val, 0.0, blend_speed * get_physics_process_delta_time())
		DIE:
			walk_val = lerpf(walk_val, 0.0, blend_speed * get_physics_process_delta_time())
			run_val = lerpf(run_val, 0.0, blend_speed * get_physics_process_delta_time())
			jump_val = lerpf(jump_val, 0.0, blend_speed * get_physics_process_delta_time())
			fall_val = lerpf(fall_val, 0.0, blend_speed * get_physics_process_delta_time())
		WALK:
			walk_val = lerpf(walk_val, 1.0, blend_speed * get_physics_process_delta_time())
			run_val = lerpf(run_val, 0.0, blend_speed * get_physics_process_delta_time())
			jump_val = lerpf(jump_val, 0.0, blend_speed * get_physics_process_delta_time())
			fall_val = lerpf(fall_val, 0.0, blend_speed * get_physics_process_delta_time())
		RUN:
			walk_val = lerpf(walk_val, 0.0, blend_speed * get_physics_process_delta_time())
			run_val = lerpf(run_val, 1.0, blend_speed * get_physics_process_delta_time())
			jump_val = lerpf(jump_val, 0.0, blend_speed * get_physics_process_delta_time())
			fall_val = lerpf(fall_val, 0.0, blend_speed * get_physics_process_delta_time())
		JUMP:
			walk_val = lerpf(walk_val, 0.0, blend_speed * get_physics_process_delta_time())
			run_val = lerpf(run_val, 0.0, blend_speed * get_physics_process_delta_time())
			jump_val = lerpf(jump_val, 1.0, blend_speed * get_physics_process_delta_time())
			fall_val = lerpf(fall_val, 0.0, blend_speed * get_physics_process_delta_time())
		FALL:
			walk_val = lerpf(walk_val, 0.0, blend_speed * get_physics_process_delta_time())
			run_val = lerpf(run_val, 0.0, blend_speed * get_physics_process_delta_time())
			jump_val = lerpf(jump_val, 0.0, blend_speed * get_physics_process_delta_time())
			fall_val = lerpf(fall_val, 1.0, blend_speed * get_physics_process_delta_time())
	
	# Aplicar al AnimationTree
	ani["parameters/Walk/add_amount"] = walk_val
	ani["parameters/Run/add_amount"] = run_val
	ani["parameters/Jump/add_amount"] = jump_val
	ani["parameters/Fall/add_amount"] = fall_val

func trigger_jump():
	# Forzar inmediatamente la animación de salto
	jump_val = 1.0
	ani["parameters/Fall/add_amount"] = jump_val

func trigger_death():
	current_anim = DIE

	# Forzar todos los valores a cero
	walk_val = 0.0
	run_val = 0.0
	jump_val = 0.0
	fall_val = 0.0
	die_val = 1.0

	# Aplica los valores al AnimationTree
	ani["parameters/Walk/add_amount"] = walk_val
	ani["parameters/Run/add_amount"] = run_val
	ani["parameters/Jump/add_amount"] = jump_val
	ani["parameters/Fall/add_amount"] = fall_val
	ani["parameters/Die/add_amount"] = die_val
