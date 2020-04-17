extends CanvasLayer

onready var label : Label = $MarginContainer/HBoxContainer/Bars/Bar/Lifetime/Label
onready var progress_bar : TextureProgress = $MarginContainer/HBoxContainer/Bars/Bar/Lifetime/TextureProgress

const MAX_TIME : int = 60

var player_alive : bool = true

func _ready() -> void:
	progress_bar.max_value = MAX_TIME
	add_to_group("lifetime_ui")

func _process(_delta) -> void:
	if progress_bar.value <= 0 and player_alive:
		player_alive = !player_alive
		_player_death()

func decrement(amount: int) -> void:
	progress_bar.value -= amount
	label.text = str(progress_bar.value)

func increment(amount: int) -> void:
	progress_bar.value += amount
	label.text = str(progress_bar.value)
	
func _player_death() -> void:
	get_tree().call_group("player", "die", null)
