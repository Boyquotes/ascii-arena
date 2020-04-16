extends KinematicBody2D

export (Vector2) var bullet_direction
export (float) var bullet_range 
export (float) var bullet_speed

func explode():
	get_parent().remove_child(self)

func _physics_process(_delta):
	var collision_info = move_and_collide(bullet_direction * bullet_speed)
	if collision_info:
		explode()

func _ready():
	var bullet_lifetime : float = bullet_range / bullet_speed
	var timer = Timer.new()
	timer.set_wait_time(bullet_lifetime)
	timer.connect("timeout", self, "explode") 
	add_child(timer) #to process
	timer.start() #to start
