extends Control
@onready var music_node = get_node("/root/MenuUi/SplashScreen" )

@onready var menu2 = $NewScreen/AudioNewPanel
func stop_my_panel():
	menu2.stop()
func start_my_panel():
	menu2.play()

func _on_button_star_pressed():
	$VBoxContainer/AudioButton.play()
	if music_node and music_node.has_method("stop_my_music"):
		music_node.stop_my_music()
	$NewScreen/AudioNewPanel.play()
	$AnimationPlayer.play("new_ani")

func _on_button_star_exit_pressed():
	$VBoxContainer/AudioButton.play()
	$NewScreen/AudioNewPanel.stop()
	if music_node and music_node.has_method("start_my_music"):
		music_node.start_my_music()
	$AnimationPlayer.play_backwards("new_ani")

func _on_button_load_pressed():
	$VBoxContainer/AudioButton.play()
	get_tree().change_scene_to_file("")

func _on_button_settings_pressed():
	$VBoxContainer/AudioButton.play()
	get_tree().change_scene_to_file("")

func _on_button_exit_pressed():
	$VBoxContainer/AudioButton.play()
	get_tree().quit()
