extends Control

func _on_button_star_pressed():
	$AnimationPlayer.play("new_ani")

func _on_button_star_exit_pressed():
	$AnimationPlayer.play_backwards("new_ani")

func _on_button_load_pressed():
	get_tree().change_scene_to_file("")

func _on_button_settings_pressed():
	get_tree().change_scene_to_file("")

func _on_button_exit_pressed():
	get_tree().quit()
