extends Control

func _on_button_started_pressed():
	get_tree().change_scene_to_file("res://Scenes/Ui/Menu/loading_screen.tscn")
