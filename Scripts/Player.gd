extends KinematicBody2D

onready var blood : Particles2D = $Blood

export var speed : int = 300

var velocity: Vector2

func _ready() -> void:
	yield(get_tree(), "idle_frame")
	add_to_group("player")

func _process(delta) -> void:
	handle_input()
	move_and_collide(velocity * speed * delta)
	
	if Input.is_action_just_pressed("respawn"):
		get_tree().reload_current_scene()

func handle_input() -> void:
	velocity = Vector2.ZERO
	velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

func hit(damage: int) -> void:
	get_tree().call_group("lifetime_ui", "decrement", damage if damage else 1)

func die() -> void:
	remove_child($Gun)
	
	rotation += 90
	speed = 0
	blood.emitting = true
