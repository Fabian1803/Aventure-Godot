extends Control

@export var radio := 100.0

var direccion := Vector2.ZERO
var tocando := false

@onready var fondo := $SpriteRango
@onready var palanca := $SpritePalanca

func _ready():
	set_process_input(true)
	fondo.visible = false
	palanca.visible = false

func _input(event):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			# Verificamos si está en la mitad izquierda de la pantalla
			if event.position.x > get_viewport().size.x * 0.5:
				return  # Ignorar si está en la mitad derecha

			tocando = true
			var pos = event.position
			fondo.position = pos - fondo.size * 0.5
			palanca.position = pos - palanca.size * 0.5
			fondo.visible = true
			palanca.visible = true
			_actualizar_palanca(pos)
		else:
			tocando = false
			fondo.visible = false
			palanca.visible = false
			direccion = Vector2.ZERO

	elif (event is InputEventScreenDrag or event is InputEventMouseMotion) and tocando:
		_actualizar_palanca(event.position)


func _actualizar_palanca(pos: Vector2):
	var centro = fondo.position + fondo.size * 0.5
	var delta = pos - centro

	if delta.length() > radio:
		delta = delta.normalized() * radio

	palanca.position = centro + delta - palanca.size * 0.5
	direccion = delta.normalized()

func get_direccion() -> Vector2:
	return direccion
