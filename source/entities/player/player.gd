class_name Player extends KinematicBody2D

# Private constants

const __SPEED_BASE: float = 500.0
const __SPEED_DASH: float = 1000.0


# Private variables

var __speed_dash: float = 0

# Lifecycle methods

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()


	if __speed_dash == 0.0 && Input.is_action_just_pressed("dash"):
		__speed_dash = __SPEED_DASH

	__speed_dash = max(0.0, __speed_dash - delta * __SPEED_DASH)

	var speed: float = __SPEED_BASE + __speed_dash



	move_and_slide(direction * speed, Vector2.UP, false)
