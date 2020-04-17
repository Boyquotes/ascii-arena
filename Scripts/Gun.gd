extends KinematicBody2D

signal camera_shake_requested

onready var bullet : = load("res://Scenes/Bullet.tscn")

export (float) var muzzle_velocity : = 1500.0
export (float) var bullet_range : = 500.0

var mouse_pos : Vector2

func _ready() -> void:
	add_to_group("camera_shaker")

func _process(_delta):
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("shoot"):
		shoot(global_position)

func _on_Enemy_hit() -> void:
	emit_signal("camera_shake_requested")

func shoot(mouse_pos) -> void:
	var bullet_instance = bullet.instance()
	bullet_instance.position = $BulletSpawn.get_global_position()
	bullet_instance.rotation_degrees = self.rotation_degrees
	bullet_instance.bullet_direction = (bullet_instance.position - mouse_pos).normalized()
	bullet_instance.bullet_speed = muzzle_velocity
	bullet_instance.bullet_range = bullet_range
	bullet_instance.connect("enemy_hit", self, "_on_Enemy_hit")
	get_tree().get_root().add_child(bullet_instance)
	$FireNoise.play()
