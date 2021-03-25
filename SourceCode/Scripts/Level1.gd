extends Node2D

signal nav

onready var nav_2d : Navigation2D = $Navigation2D
onready var player : KinematicBody2D = $Player

var collected_counter = 0
var next_level = false


func player_dead(value):
	get_tree().reload_current_scene()


func _unhandled_input(event: InputEvent) -> void:
	emit_signal("nav", nav_2d)


func _on_punch (punch, _position, _direction):
	var p = punch.instance()
	add_child(p)
	p.start(_position, _direction)


func _on_collected():
	collected_counter += 1
	if collected_counter == 10:
		next_level = true
	
	
func next_level():
	if next_level == true:
		get_tree().change_scene("res://Scenes/Level2.tscn")
