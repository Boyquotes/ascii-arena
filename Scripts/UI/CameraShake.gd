extends Camera2D

# code from
# Godot Game Juice Tutorial 1: Camera Shake and Frame Freeze by GDQuest
# https://www.youtube.com/watch?v=AobjNjzZhmo

onready var timer : Timer = $Timer

export var amplitude : = 3.0
export var duration : = 0.4 setget set_duration
export (float, EASE) var DAMP_EASING : = 1.0
export var shake : = false setget set_shake
export var delay_mseconds : = 50

var enabled : = true

func _ready() -> void:
	randomize()
	set_process(false)
	self.duration = duration
	connect_to_shakers()

func _process(delta: float) -> void:
	var damping : = ease(timer.time_left / timer.wait_time, DAMP_EASING)
	offset = Vector2(
		rand_range(amplitude, -amplitude) * damping,
		rand_range(amplitude, -amplitude) * damping
	)

func _on_ShakeTimer_timeout() -> void:
	self.shake = false

func _on_camera_shake_requested() -> void:
	if not enabled:
		return
	self.shake = true

func set_duration(value: float) -> void:
	duration = value
	timer.wait_time = duration

func set_shake(value: bool) -> void:
	shake = value
	set_process(shake)
	offset = Vector2()
	if shake:
		OS.delay_msec(25)
		timer.connect("timeout", self, "_on_ShakeTimer_timeout")
		timer.start()

func connect_to_shakers() -> void:
	yield(get_tree(), "idle_frame")
	for camera_shaker in get_tree().get_nodes_in_group("camera_shaker"):
		camera_shaker.connect("camera_shake_requested", self, "_on_camera_shake_requested")

