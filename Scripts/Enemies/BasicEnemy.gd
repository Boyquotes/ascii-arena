extends KinematicBody2D

onready var blood : Particles2D = $Blood
export var speed : int = 180

var target = null

var dead : bool = false

func _ready():
	add_to_group("enemies")
	
func _physics_process(delta):
	if target == null:
		return
	
	if dead == false:
		var vec_to_player = (target.global_position - global_position).normalized()

		global_rotation = atan2(vec_to_player.y, vec_to_player.x)
		var collision_info = move_and_collide(vec_to_player * speed * delta)
		if collision_info:
			var collider = collision_info.get_collider()
			if collider.has_method("hit") and !collider.is_in_group("enemies"):
				collider.hit()

func set_target(t):
	target = t

func hit():
	die()

func delete_self():
	get_parent().remove_child(self)

func die():
	if !dead:
		dead = !dead
		
		set_collision_layer_bit(0, false)
		set_collision_mask_bit(0, false)
		
		speed = 0
		rotation += 90
		blood.emitting = true
		
		var timer = Timer.new()
		timer.set_wait_time(5)
		timer.connect("timeout", self, "delete_self")
		add_child(timer) #to process
		timer.start() #to start
