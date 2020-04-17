extends Node2D

onready var timer : Timer = $Timer

var monster_scenes = [load("res://Scenes/Enemies/EnemyV.tscn"), load("res://Scenes/Enemies/EnemyW.tscn"), load("res://Scenes/Enemies/EnemyK.tscn")]

func _ready() -> void:
	randomize()
	timer.wait_time = 5.0
	timer.connect("timeout", self, "spawn")
	timer.start()

func spawn() -> void:
	var selection : int = randi() % monster_scenes.size()
	var new_enemy = monster_scenes[selection].instance()
	new_enemy.position = global_position
	get_tree().get_root().add_child(new_enemy)

	timer.start()
