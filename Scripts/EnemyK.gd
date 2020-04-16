extends KinematicBody2D

onready var raycast = $RayCast2D
var target = null
var default_speed = 300
var speed

var dead : bool = false


func toggle_slow_walk():
	var timer = Timer.new()
	timer.set_wait_time(2)
	timer.connect("timeout", self, "toggle_fast_walk") 
	add_child(timer) #to process
	timer.start() #to start
	
	speed = default_speed / 10
	
func toggle_fast_walk():
	var timer = Timer.new()
	timer.set_wait_time(2)
	timer.connect("timeout", self, "toggle_slow_walk") 
	add_child(timer) #to process
	timer.start() #to start

	speed = default_speed

func set_target(t):
	target = t
	
func _ready():
	add_to_group("enemies")
	toggle_slow_walk()
	
func _physics_process(delta):
	if target == null:
		return
	
	if dead == false:
		var vec_to_player = (target.global_position - global_position).normalized()
		global_rotation = atan2(vec_to_player.y, vec_to_player.x)
		var collision_info = move_and_collide(vec_to_player * speed * delta)
		if collision_info:
			var collider = collision_info.get_collider()
			if collider.has_method("hit"):
				collider.hit()

func hit():
	die()

func delete_self():
	get_parent().remove_child(self)

func die():
	if !dead:
		dead = !dead
		speed = 0
		rotation += 90
		$Blood.emitting = true
		
		var timer = Timer.new()
		timer.set_wait_time(5)
		timer.connect("timeout", self, "delete_self")
		add_child(timer) #to process
		timer.start() #to start
