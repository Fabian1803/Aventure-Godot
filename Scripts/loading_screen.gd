extends Control

func _ready():
	$Timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	get_tree().change_scene_to_file("res://Scenes/World/word.tscn")
