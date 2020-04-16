extends KinematicBody2D

const BASE_SPEED = 300
const PLAYER_MODIFIER = 1
const MONST_MODIFIER = 0.8

export var velocity = Vector2.ZERO

func handle_movement(speed_modifier):
	move_and_slide(velocity * speed_modifier)
