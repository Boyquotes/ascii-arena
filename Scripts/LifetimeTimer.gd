extends CanvasLayer

onready var timer : Timer = $Timer
onready var progress_bar : TextureProgress = $MarginContainer/HBoxContainer/Bars/Bar/Lifetime/TextureProgress
onready var score_label : Label = $MarginContainer/HBoxContainer/Counters/Score/Label

const MAX_TIME : float = 60.0

var player_alive : bool = true
var score : float = 0.0

func _ready() -> void:
	timer.wait_time = 1.0
	timer.connect("timeout", self, "_countdown")
	progress_bar.max_value = MAX_TIME
	add_to_group("lifetime_ui")
	timer.start()

func _process(delta) -> void:

	if progress_bar.value <= 0 and player_alive:
		player_alive = !player_alive
		_player_death()

func decrement(amount: float) -> void:
	progress_bar.value -= amount

func increment(amount: float) -> void:
	progress_bar.value += amount
	score += amount
	update_score_ui()

func _player_death() -> void:
	get_tree().call_group("player", "die", null)

func _countdown() -> void:
	decrement(1.0)
	timer.start()

func update_score_ui() -> void:
	score_label.text = "Score: " + str(score)
