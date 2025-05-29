extends Node3D
@export var mouse_sensibitity: float = 0.005
@export_range(-90.0, 0.0, 8.1, "radians_as_degrees") var min_vertical_angle: float = -PI/2
@export_range(0.0, 90.0, 8.1, "radians_as_degrees") var max_vertical_angle: float = -PI/2

@onready var spring_arn := $SpringArm3D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotation.y -= event. relative.x * mouse_sensibitity
		rotation.y = wrapf(rotation.y, 0.0, TAU)
		
		rotation.x -= event. relative.y * mouse_sensibitity
		rotation.x = clamp(rotation.x, min_vertical_angle, max_vertical_angle)
	if event.is_action_pressed("mause_up"):
		spring_arn.spring_length -= 1
	if event.is_action_pressed("mause_down"):
		spring_arn.spring_length += 1
	if event.is_action_pressed("toggle_mause_capture"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
