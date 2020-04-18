extends KinematicBody2D

onready var blood : Particles2D = $Blood
onready var cooldown_timer : Timer = $Timer
onready var raycast : RayCast2D = $RayCast2D

export var speed : float = 180.0
export var damage : float = 5.0
export var hit_rate : float = 2.0
export var max_health : float = 20.0

var target = null
var dead : bool = false
var can_hit : bool = true

var score : float
var health : float

func _ready():
	randomize()
	score = ((speed / 180.0) * (damage / 5.0) * (hit_rate / 2.0) * (max_health / 20.0)) * 3.0
	health = max_health
	cooldown_timer.wait_time = 1.0 / hit_rate
	cooldown_timer.connect("timeout", self, "_on_cooldown")
	add_to_group("enemies")
	
func _process(delta):
	if dead == false:
		if target == null:
			global_rotation += (0.25 + randi() % 5) * delta
			if raycast.is_colliding():
				var collider = raycast.get_collider()
				if collider.is_in_group("player"):
					target = collider
		else:
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

func hit(damage: float) -> void:
	health -= damage
	if health < 0:
		die()

func delete_self() -> void:
	get_parent().remove_child(self)

func die() -> void:
	if !dead:
		dead = !dead
		
		get_tree().call_group("lifetime_ui", "increment", score)
		
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
