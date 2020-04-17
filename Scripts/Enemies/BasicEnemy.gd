extends KinematicBody2D

onready var blood : Particles2D = $Blood
onready var cooldown_timer : Timer = $Timer

export var speed : int = 180
export var damage : int = 5
export var hit_rate : float = 2.0

var target = null
var dead : bool = false
var can_hit : bool = true

func _ready():
	cooldown_timer.wait_time = 1.0 / hit_rate
	cooldown_timer.connect("timeout", self, "_on_cooldown")
	add_to_group("enemies")
	
func _process(delta):
	if target == null:
		return
	
	if dead == false:
		var vec_to_player = (target.global_position - global_position).normalized()

		global_rotation = atan2(vec_to_player.y, vec_to_player.x)
		var collision_info = move_and_collide(vec_to_player * speed * delta)
		if collision_info:
			var collider = collision_info.get_collider()
			if collider.has_method("hit") and !collider.is_in_group("enemies") and can_hit:
				can_hit = !can_hit
				cooldown_timer.start()
				collider.hit(damage)

func _on_cooldown() -> void:
	can_hit = true

func set_target(t) -> void:
	target = t

func hit() -> void:
	die()

func delete_self() -> void:
	get_parent().remove_child(self)

func die() -> void:
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
