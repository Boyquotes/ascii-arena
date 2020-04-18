extends KinematicBody2D

signal enemy_hit

export (Vector2) var bullet_direction
export (float) var bullet_range 
export (float) var bullet_speed
export (float) var bullet_damage

func _ready() -> void:
	var bullet_lifetime : float = bullet_range / bullet_speed
	var timer = Timer.new()
	timer.set_wait_time(bullet_lifetime)
	timer.connect("timeout", self, "explode") 
	add_child(timer)
	timer.start()

func _physics_process(delta: float):
	var collision_info = move_and_collide(bullet_direction * bullet_speed * delta)
	if collision_info:
		var collider = collision_info.get_collider()
		if collider.has_method("hit"):
			emit_signal("enemy_hit")
			collider.hit(bullet_damage)
		explode()

func explode():
	get_parent().remove_child(self)	
