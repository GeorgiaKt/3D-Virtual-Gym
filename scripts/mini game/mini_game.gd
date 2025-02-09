extends Node

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var player: CharacterBody2D = $Player

func _ready() -> void:
	# Connect the player's signal to update the progress bar
	player.update_progress.connect(_on_Player_update_progress)


# Function to update progress bar when the player's signal is emitted
func _on_Player_update_progress(value: int) -> void:
	progress_bar.value = value
