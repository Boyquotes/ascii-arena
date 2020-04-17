extends Node

onready var kinematicbody : KinematicBody2D = get_parent().get_node("KinematicBody2D")
onready var default_speed : int = kinematicbody.speed

func _ready() -> void:
	toggle_slow_walk()

func toggle_slow_walk() -> void:
	var timer : Timer = Timer.new()
	timer.set_wait_time(2)
	timer.connect("timeout", self, "toggle_fast_walk") 
	kinematicbody.add_child(timer) #to process
	timer.start() #to start
	
	kinematicbody.speed = default_speed / 10
	
func toggle_fast_walk() -> void:
	var timer : Timer = Timer.new()
	timer.set_wait_time(2)
	timer.connect("timeout", self, "toggle_slow_walk") 
	kinematicbody.add_child(timer) #to process
	timer.start() #to start

	kinematicbody.speed = default_speed
