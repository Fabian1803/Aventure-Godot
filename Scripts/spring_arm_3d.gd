extends Node3D

@export var touch_sensitivity: float = 0.005
@export_range(-90.0, 0.0, 8.1, "radians_as_degrees") var min_vertical_angle: float = deg_to_rad(-80)
@export_range(0.0, 90.0, 8.1, "radians_as_degrees") var max_vertical_angle: float = deg_to_rad(60)

@onready var spring_arm := $SpringArm3D

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		var drag: Vector2 = event.relative
		rotation.y -= drag.x * touch_sensitivity  # Horizontal
		rotation.y = wrapf(rotation.y, 0.0, TAU)

		rotation.x -= drag.y * touch_sensitivity  # Vertical
		rotation.x = clamp(rotation.x, min_vertical_angle, max_vertical_angle)
