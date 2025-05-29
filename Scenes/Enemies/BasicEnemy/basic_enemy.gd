extends BaseEnemy

@onready var front_ray: RayCast3D = $RayCast3D
@onready var anim_manager = $"character-zombie"
@export var fuerza_salto: float = 4.5
@export var gravedad: float = 9.8
@export var tiempo_entre_ataques: float = 1.5  # 1.5 segundos entre ataques
var ataque_cargando := false

var puede_atacar := true
var player: CharacterBody3D = null
var player_in_range := false
var jugador_sigue_en_rango = true

func _physics_process(delta: float) -> void:
	if player != null and player_in_range:
		movimiento(delta)
	else:
		if not is_on_floor():
			velocity.y -= gravedad * delta
		else:
			velocity.y = 0
		velocity.x = 0
		velocity.z = 0
		anim_manager.update_movement(Vector3.ZERO, is_on_floor(), false)
		move_and_slide()


func movimiento(delta: float) -> void:
	var direction_to = player.global_position - global_position
	direction_to.y = 0
	var direction = direction_to.normalized()

	anim_manager.update_movement(velocity, is_on_floor(), false)

	velocity.x = direction.x * velocidad * delta * 2
	velocity.z = direction.z * velocidad * delta * 2

	if front_ray.is_colliding() and is_on_floor():
		var collider = front_ray.get_collider()
		if collider.name == "Player" and puede_atacar and not ataque_cargando:
			ataque_cargando = true
			puede_atacar = false
			anim_manager.trigger_attack()  # Animación de ataque

			# Iniciar el proceso de daño con delay
			_apply_damage_delayed(collider)
			_iniciar_cooldown_ataque()
		if collider.name == "Player" and puede_atacar:
			puede_atacar = false
			anim_manager.trigger_attack()
			collider.recibir_danio(1)
			_iniciar_cooldown_ataque()

	if not is_on_floor():
		velocity.y -= gravedad * delta

	var target_pos = player.global_position
	target_pos.y = global_position.y
	var target_rotation = transform.looking_at(target_pos, Vector3.UP).basis.get_rotation_quaternion()
	var current_rotation = global_transform.basis.get_rotation_quaternion()
	global_transform.basis = Basis(current_rotation.slerp(target_rotation, delta * 10))

	move_and_slide()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		player = body
		player_in_range = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		player = null
		player_in_range = false
		anim_manager.update_movement(Vector3.ZERO, is_on_floor(), false)
		jugador_sigue_en_rango = false
		ataque_cargando = false
		puede_atacar = true
		anim_manager.stop_attack()  # Aquí crea este método para resetear animación
		anim_manager.update_movement(Vector3.ZERO, is_on_floor(), false)



func _iniciar_cooldown_ataque():
	await get_tree().create_timer(tiempo_entre_ataques).timeout
	puede_atacar = true

func _apply_damage_delayed(player_body):
	var tiempo_espera = 0.3
	var tiempo_transcurrido = 0.0
	var intervalo = 0.05  # chequeo cada 0.1 segundos

	while tiempo_transcurrido < tiempo_espera:
		if not jugador_sigue_en_rango:
			# El jugador se salió antes de completar el ataque
			ataque_cargando = false
			return
		await get_tree().create_timer(intervalo).timeout
		tiempo_transcurrido += intervalo

	# Si llegamos aquí es porque el jugador sigue en rango todo el tiempo
	if player_in_range and player_body == player:
		player_body.recibir_danio(1)

	ataque_cargando = false
