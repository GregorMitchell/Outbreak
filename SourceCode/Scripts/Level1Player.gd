extends KinematicBody2D

onready var sprite = get_node("Sprite")

signal punch
signal health_changed
signal dead

export (PackedScene) var Punch
export (float) var punch_cooldown
export (int) var health_cooldown
export (int) var max_health

const speed = 100
var can_punch = true
var alive = true
var regen_health = true
var health
var walking = false

func _ready():
	health = max_health
	emit_signal('health_changed', health * 100/max_health)
	$PunchTimer.wait_time = punch_cooldown
	$HealthTimer.wait_time = health_cooldown
	sprite.play("NormalIdle")
	
func _physics_process(delta):
	if not alive:
		return
	var move_vec = Vector2()
	if Input.is_action_pressed("move_up"):
		move_vec.y -= 1
		walking = true
	if Input.is_action_pressed("move_down"):
		move_vec.y += 1
		walking = true
	if Input.is_action_pressed("move_left"):
		move_vec.x -= 1
		walking = true
	if Input.is_action_pressed("move_right"):
		move_vec.x += 1
		walking = true
	if Input.is_action_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("punch"):
		punch()
	move_vec = move_vec.normalized()
	move_and_collide(move_vec * speed * delta)
	
	if Input.is_action_just_released("move_up"):
		sprite.play("NormalIdle")
		walking = false
	if Input.is_action_just_released("move_down"):
		sprite.play("NormalIdle")
		walking = false
	if Input.is_action_just_released("move_left"):
		sprite.play("NormalIdle")
		walking = false
	if Input.is_action_just_released("move_right"):
		sprite.play("NormalIdle")
		walking = false
		
	if walking:
		sprite.play("NormalWalking")

	var look_vec = get_global_mouse_position() - global_position
	global_rotation = atan2(look_vec.y, look_vec.x)
	
	if regen_health == true:
		if health < max_health:
			health += 20
			regen_health = false
			$HealthTimer.start()
			emit_signal('health_changed', health * 100/max_health)


func _on_HealthTimer_timeout():
	regen_health = true


func punch():
	if can_punch:
		sprite.visible = false
		$PunchSprite.visible = true
		can_punch = false
		$PunchTimer.start()
		var dir2 = Vector2(1,0).rotated(global_rotation)
		emit_signal('punch', Punch, $Puncher.global_position, dir2)


func _on_PunchTimer_timeout():
	can_punch = true
	sprite.visible = true
	$PunchSprite.visible = false


func take_damage(amount):
	health -= amount
	emit_signal('health_changed', health * 100/max_health)
	$Sprite.play("Hurt")
	if health <= 0:
		alive = false
		emit_signal('dead', alive)
		die()


func die():
	queue_free()

