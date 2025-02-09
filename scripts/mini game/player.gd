extends CharacterBody2D

# Constants for physics behavior
const GRAVITY = 9.8  # Gravity force applied to the character
const FLAP = 200  # Strength of the flap (jump)
const MAX_FALL_SPEED = 200  # Maximum falling speed

@export var scaleY = 1  # Allows modification of the scale in the editor
var dumbbell_inside = false  # Tracks if the character is inside a detection area
var completion_perc = 0  # Progress percentage

signal update_progress(value)  # Signal to notify progress updates

func _ready() -> void:
	# Adjust scale on the Y-axis
	scale.y = scaleY

func _process(delta: float) -> void:
	# Apply gravity
	velocity.y += GRAVITY

	# Clamp falling speed
	if velocity.y > MAX_FALL_SPEED:
		velocity.y = MAX_FALL_SPEED

	# Flap (jump) mechanic when pressing the action key
	if Input.is_action_just_pressed("flap_minigame"):
		velocity.y = -FLAP

	# Move the character with the built-in velocity property
	move_and_slide()

	# Update the progress bar
	update_completion_perc()
	
func update_completion_perc():
	# Increase or decrease completion percentage based on whether inside the detection area
	if dumbbell_inside:
		completion_perc += 1
		if completion_perc > 100:
			completion_perc = 100
	else:
		completion_perc -= 1
		if completion_perc < 0:
			completion_perc = 0

	# Emit signal to notify about progress changes
	update_progress.emit(completion_perc)

# Triggered when a body enters the detection area
func _on_detection_area_2d_body_entered(body: Node2D) -> void:
	dumbbell_inside = true

# Triggered when a body exits the detection area
func _on_detection_area_2d_body_exited(body: Node2D) -> void:
	dumbbell_inside = false  # Fixed: Should set to false instead of true
