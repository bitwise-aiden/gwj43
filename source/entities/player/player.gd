class_name Player extends KinematicBody2D

# Private constants

const __SPEED_BASE: float = 500.0
const __SPEED_DASH: float = 1000.0


# Private variables

var __bomb_count: int = 0
var __speed_dash: float = 0

# Lifecycle methods

func _physics_process(delta: float) -> void:
	__movement(delta)
	__abilities(delta)


# Public methods

func damage() -> void:
	print("Damaged")


func pick_up(type: PickUpType) -> void:
	match type.name:
		"Bomb":
			__bomb_count += 1


# Public methods

func __abilities(delta: float) -> void:
	if __bomb_count && Input.is_action_just_pressed("bomb"):
		if ProjectileSpawner.spawn_bomb(position):
			__bomb_count -= 1


func __movement(delta: float) -> void:
	var direction: Vector2 = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()

	if __speed_dash == 0.0 && Input.is_action_just_pressed("dash"):
		__speed_dash = __SPEED_DASH

	__speed_dash = max(0.0, __speed_dash - delta * __SPEED_DASH)

	var speed: float = __SPEED_BASE + __speed_dash

	move_and_slide(direction * speed, Vector2.UP, false)
