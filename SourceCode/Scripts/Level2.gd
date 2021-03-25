extends Node2D

signal nav

onready var nav_2d : Navigation2D = $Navigation2D
onready var player : KinematicBody2D = $Player


func player_dead(value):
	get_tree().reload_current_scene()


func _unhandled_input(event: InputEvent) -> void:
	emit_signal("nav", nav_2d)


func _on_shoot(bullet, _position, _direction):
	var b = bullet.instance()
	add_child(b)
	b.start(_position, _direction)
	
	
func _on_punch(punch, _position, _direction):
	var p = punch.instance()
	add_child(p)
	p.start(_position, _direction)


func _on_Zombie_cured(cured, _position, _direction):
	var z = cured.instance()
	call_deferred("add_child", z)
	z.start(_position, _direction)


func next_level():
	get_tree().change_scene("res://Scenes/Level3.tscn")
