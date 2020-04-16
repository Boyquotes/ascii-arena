extends KinematicBody2D

export (float) var muzzle_velocity = 1500.0
export (float) var bullet_range = 500.0

onready var bullet = load("res://Scenes/Bullet.tscn")

var mouse_pos : Vector2

func shoot(mouse_pos):
	var bullet_instance = bullet.instance()
	bullet_instance.position = $BulletSpawn.get_global_position()
	bullet_instance.rotation_degrees = self.rotation_degrees
	bullet_instance.bullet_direction = (bullet_instance.position - mouse_pos).normalized()
	bullet_instance.bullet_speed = muzzle_velocity
	bullet_instance.bullet_range = bullet_range
	get_tree().get_root().add_child(bullet_instance)
	$FireNoise.play()

func _physics_process(delta):
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("shoot"):
		shoot(global_position)
		
	if Input.is_action_just_pressed("respawn"):
		get_tree().reload_current_scene()
