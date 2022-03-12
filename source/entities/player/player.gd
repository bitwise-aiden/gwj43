class_name Player extends KinematicBody2D

# Private constants

const __BASE_SPEED: float = 500.0

# Lifecycle methods

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()

	var speed: float = __BASE_SPEED

	move_and_slide(direction * speed, Vector2.UP, false)
