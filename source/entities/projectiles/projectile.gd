class_name Projectile extends KinematicBody2D


# Protected methods

var _direction: Vector2 = Vector2.ZERO # Friend: ProjectileSpawner


# Lifecycle methods

func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	var velocity: Vector2 = _calculated_velocity(delta)

	var result: KinematicCollision2D = move_and_collide(velocity)
	if result && result.collider:
		var other: Node2D = result.collider

		if other.has_method("damage"):
			other.damage()

		_hit()
		queue_free()


# Protected methods

func _calculated_velocity(delta: float) -> Vector2:
	return Vector2.ZERO


func _hit() -> void:
	pass
