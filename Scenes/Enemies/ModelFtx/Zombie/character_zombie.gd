extends Node3D

@onready var ani = $Ani

enum {IDLE, WALK, JUMP, FALL, ATTACK}
var current_anim = IDLE
var blend_speed = 15.0
var attack_val = 0.0
var walk_val = 0.0
var jump_val = 0.0
var fall_val = 0.0

func update_movement(velocity: Vector3, is_on_floor: bool, is_sprinting: bool):
	if current_anim == ATTACK:
		return # Mientras ataca, no cambiar animación
	if not is_on_floor:
		current_anim = FALL if velocity.y < 0 else JUMP
	elif Vector2(velocity.x, velocity.z).length() > 0.1:
		current_anim = WALK
	else:
		current_anim = IDLE
	
	# Actualizar valores de blend
	match current_anim:
		IDLE:
			walk_val = 0.0
			jump_val = 0.0
			fall_val = 0.0
			attack_val = 0.0
		WALK:
			walk_val = 1.0
			jump_val = 0.0
			fall_val = 0.0
			attack_val = 0.0
		JUMP:
			walk_val = 0.0
			jump_val = 1.0
			fall_val = 0.0
			attack_val = 0.0
		FALL:
			walk_val = 0.0
			jump_val = 0.0
			attack_val = 0.0
			fall_val = 1.0

	# Aplicar al AnimationTree
	ani["parameters/walk/blend_amount"] = walk_val
	ani["parameters/jump/blend_amount"] = jump_val
	ani["parameters/fall/blend_amount"] = fall_val
	ani["parameters/atack/blend_amount"] = attack_val


func trigger_jump():
	jump_val = 1.0
	ani["parameters/jump/blend_amount"] = jump_val

func trigger_attack():
	current_anim = ATTACK
	attack_val = 1.0

	# Cortar el resto de animaciones
	walk_val = 0.0
	jump_val = 0.0
	fall_val = 0.0

	# Aplicar solo ataque
	ani["parameters/atack/blend_amount"] = attack_val

func stop_attack():
	if current_anim == ATTACK:
		current_anim = IDLE
		attack_val = 0.0
		walk_val = 0.0
		jump_val = 0.0
		fall_val = 0.0
		ani["parameters/atack/blend_amount"] = attack_val
		ani["parameters/walk/blend_amount"] = walk_val
		ani["parameters/jump/blend_amount"] = jump_val
		ani["parameters/fall/blend_amount"] = fall_val
