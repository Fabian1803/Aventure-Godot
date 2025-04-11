extends Control

func _input(event):
	if event is InputEventKey and event.pressed:
		if $slap1/slap1.has_animation("slap1") and $slap1/slap1.is_playing():
			$slap1/slap1.seek($slap1/slap1.get_animation("slap1").length)
			$slap1/slap1.speed_scale = 10.0
		
		if $slap2/AnimationPlayer.has_animation("slap2") and $slap2/AnimationPlayer.is_playing():
			$slap2/AnimationPlayer.seek($slap2/AnimationPlayer.get_animation("slap2").length)
			$slap2/AnimationPlayer.speed_scale = 10.0
		
		if $BoxContainer/AnimationPlayer2.has_animation("clouds") and $BoxContainer/AnimationPlayer2.is_playing():
			$BoxContainer/AnimationPlayer2.seek($BoxContainer/AnimationPlayer2.get_animation("clouds").length)
			$BoxContainer/AnimationPlayer2.speed_scale = 10.0
		
		if $BoxContainer/AnimationPlayer2.has_animation("clouds") and $BoxContainer/AnimationPlayer2.is_playing():
			$BoxContainer/AnimationPlayer2.seek($BoxContainer/AnimationPlayer2.get_animation("clouds").length)
			$BoxContainer/AnimationPlayer2.speed_scale = 10.0
			
		if $bird/AnimationPlayer.has_animation("bird") and $bird/AnimationPlayer.is_playing():
			$bird/AnimationPlayer.seek($bird/AnimationPlayer.get_animation("bird").length)
			$bird/AnimationPlayer.speed_scale = 10.0
