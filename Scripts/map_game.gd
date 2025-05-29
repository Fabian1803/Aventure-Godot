extends Control


func _on_button_salir_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Ui/Menu/menu_ui.tscn")


func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Maps/Lvl1/lvl1.tscn")
