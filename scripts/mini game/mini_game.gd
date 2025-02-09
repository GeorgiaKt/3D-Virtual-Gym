extends Node

@onready var progress_bar: ProgressBar = $MiniGameUI/ProgressBar
@onready var player: CharacterBody2D = $Player

func _ready() -> void:
	# Connect the player's signal to update the progress bar
	player.update_progress.connect(_on_Player_update_progress)
	
	# Set the initial value of the progress bar
	progress_bar.value = 1

# Function to update progress bar when the player's signal is emitted
func _on_Player_update_progress(value: int) -> void:
	progress_bar.value = value
