extends KinematicBody2D

onready var sprite = get_node("Sprite")

signal cured

export (PackedScene) var Cured
export (int) var damage
export (int) var attack_cooldown
export (int) var detect_start_radius
export (int) var detect_stop_radius

var path : = PoolVector2Array() setget set_path
var speed : = 50
var can_shoot = true
var alive = true
var player = null
var active_zombie = false
var stunned = false
var nav_2d
var attacking = false
var rng = RandomNumberGenerator.new()
var random_dir
onready var parent = get_parent()
var x = Vector2(0,0)


func _ready() -> void:
	rng.randomize()
	random_dir = rng.randf_range(0, 359)
	set_global_rotation_degrees(random_dir)
	set_process(false)
	$ZombieStart/CollisionShape2D.shape.radius = detect_start_radius
	$ZombieStop/CollisionShape2D.shape.radius = detect_stop_radius
	$AttackCooldown.wait_time = attack_cooldown
	sprite.play("Idle")
	
	
func receive_nav(value):
	nav_2d = value


func _input(event: InputEvent) -> void:
	if player:
		var new_path = nav_2d.get_simple_path(global_position, player.global_position)
		path = new_path


func _physics_process(delta : float) -> void:
	var move_distance : = speed * delta
	move_along_path(move_distance)
	if alive == true:
		if active_zombie == true:
			sprite.play("Walking")
			var look_vec = player.global_position - global_position
			global_rotation = atan2(look_vec.y, look_vec.x)


func move_along_path(distance : float) -> void:
	if alive == true:
		if stunned == false:
			var start_point : = global_position
			for _i in range(path.size()):
				var distance_to_next : = start_point.distance_to(path[0])
				if distance <= distance_to_next and distance >= 0.0:
					position = start_point.linear_interpolate(path[0], distance/distance_to_next)
					move_and_collide(x)
					break
				elif distance < 0.0:
					position = path[0]
				distance -= distance_to_next
				start_point = path[0]
				path.remove(0)


func set_path(value : PoolVector2Array) -> void:
	path = value
	if value.size() == 0:
		return
	set_process(true)


func _on_ZombieStart_body_entered(body):
	if body.name == "Player":
		player = body
		active_zombie = true


func _on_ZombieStop_body_exited(body):
	if body == player:
		player = null
		active_zombie = false
		sprite.play("Idle")


func _on_ZombieAttack_body_entered(body):
		if stunned == false:
			if body.has_method('take_damage'):
				body.take_damage(damage)
				attacking = true
				$AttackCooldown.start()


func _on_AttackCooldown_timeout():
	if attacking == true:
		_on_ZombieAttack_body_entered(player)


func _on_ZombieAttack_body_exited(body):
	attacking = false


func get_punched():
	stunned = true
	$Sprite.visible = false
	$Stunned.visible = true
	$StunnedTimer.start()


func _on_StunnedTimer_timeout():
	stunned = false
	$Sprite.visible = true
	$Stunned.visible = false
	
func get_shot():
	if stunned == true:
		alive = false
		cured()

func cured():
	var dir = Vector2(1,0).rotated(global_rotation)
	emit_signal('cured', Cured, global_position, dir)
	queue_free()

