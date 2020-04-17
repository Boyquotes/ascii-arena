extends CanvasLayer

signal player_death

onready var label : Label = $MarginContainer/HBoxContainer/Bars/Bar/Lifetime/Label
onready var progress_bar : TextureProgress = $MarginContainer/HBoxContainer/Bars/Bar/Lifetime/TextureProgress

const MAX_TIME : int = 60

func _ready() -> void:
	progress_bar.max_value = MAX_TIME
	add_to_group("lifetime_ui")

func decrement(amount: int) -> void:
	progress_bar.value -= amount
	label.text = str(progress_bar.value)

func increment(amount: int) -> void:
	progress_bar.value += amount
	label.text = str(progress_bar.value)
