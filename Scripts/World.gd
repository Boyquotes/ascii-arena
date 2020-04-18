extends Node2D

onready var spawn_timer : Timer = $SpawnTimer
onready var ground_tilemap : TileMap = $Ground
onready var enemies = [load("res://Scenes/Enemies/EnemyV.tscn"), load("res://Scenes/Enemies/EnemyW.tscn"), load("res://Scenes/Enemies/EnemyK.tscn")]

var spawn_freq : int = 5

var min_x : float = 0.0
var min_y : float = 0.0

var max_x : float = 0.0
var max_y : float = 0.0


func _ready() -> void:
	calculate_bounds()
	randomize()
	spawn_timer.wait_time = spawn_freq
	spawn_timer.connect("timeout", self, "spawn_enemy")
	spawn_timer.start()

func spawn_enemy() -> void:
	var new_enemy = enemies[randi() % enemies.size()].instance()
	var new_pos = Vector2(rand_range(min_x, max_x), rand_range(min_y, max_y))
	new_enemy.position = new_pos
	get_parent().add_child(new_enemy)
	print("Enemy spawned! ", new_enemy, "at ", new_pos)


func calculate_bounds():
	var used_cells = ground_tilemap.get_used_cells()
	for pos in used_cells:
		if pos.x < min_x:
			min_x = int(pos.x)
		elif pos.x > max_x:
			max_x = int(pos.x)
		if pos.y < min_y:
			min_y = int(pos.y)
		elif pos.y > max_y:
			max_y = int(pos.y)

	# We don't want to spawn inside walls
	# We can put wall-checking logic somewhere else later
	min_x += 1
	min_y += 1
	max_x -= 1
	max_y -= 1
	
	# Convert tiles to pixels. This is really bad practice (use of magic number)
	# but we can fix this later
	min_x *= 81
	min_y *= 81
	max_x *= 81
	max_y *= 81
	
	
	print("Bounds: ", min_x," ", min_y, " ", max_x, " ", max_y )

