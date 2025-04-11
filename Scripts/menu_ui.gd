extends Control


func _input(event):
	if event is InputEventKey and event.pressed:
		if $AnimationPlayer.has_animation("menuui") and $AnimationPlayer.is_playing():
			$AnimationPlayer.seek($AnimationPlayer.get_animation("menuui").length)
			$AnimationPlayer.speed_scale = 10.0
