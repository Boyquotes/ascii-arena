extends "res://Scripts/Entity.gd"

func handle_input():
	velocity = Vector2.ZERO
	velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

func _physics_process(delta):
	handle_input()
	handle_movement(BASE_SPEED * PLAYER_MODIFIER)
