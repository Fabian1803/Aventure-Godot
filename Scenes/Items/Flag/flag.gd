extends Area3D

var fade_scene := preload("res://Scenes/Items/Flag/flag_fade.tscn")
var fade_instance
var animation_player
var triggered := false

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	fade_instance = fade_scene.instantiate()
	get_tree().current_scene.call_deferred("add_child", fade_instance)

	var rect = fade_instance.get_node("ColorRect")
	rect.modulate.a = 0  # ¡Importante! Iniciar transparente

	animation_player = fade_instance.get_node("ColorRect/AnimationPlayer")
	animation_player.connect("animation_finished", Callable(self, "_on_animation_finished"))

	fade_instance.visible = false  
	fade_instance.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_body_entered(body):
	if triggered:
		return
	if body.name == "Player":
		triggered = true
		fade_instance.visible = true
		animation_player.play("fade_out")

func _on_animation_finished(anim_name):
	if anim_name == "fade_out":
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().change_scene_to_file("res://Scenes/Ui/Game/map-game.tscn")
