extends CharacterBody2D

@export var speed: float = 80  # Movement speed
@export var maxTop: float = 70  # Upper boundary for movement
@export var maxBottom: float = 70  # Lower boundary for movement

var target: Vector2  # Target position for movement

func _ready() -> void:
	target = position  # Start with current position
	update_target()  # Set initial target

func _process(delta: float) -> void:
	# Move towards the target using direction and speed
	velocity = (target - position).normalized() * speed  # Calculate velocity towards target

	# If not at the target, continue moving
	if position.distance_to(target) > 1:
		move_and_slide()  # No need to pass arguments in Godot 4
	else:
		update_target()  # Choose a new target once reached

func update_target() -> void:
	# Generate a random Y position within bounds
	target.y = randf_range(maxTop, maxBottom)
