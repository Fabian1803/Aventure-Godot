extends Node
var current_music: AudioStreamPlayer

func stop_menu_music():
	if current_music:
		current_music.stop()
