class_name ProjectileVortex extends Projectile


# Private constants

const __SPEED: float = 10.0


# Private variables

onready var __sprite: Sprite = $sprite


# Lifecycle methods

func _process(delta: float) -> void:
	__sprite.rotation += delta * 2.0 * sign(_direction.x)


# Protected methods

func _calculated_velocity(delta: float) -> Vector2:
	return _direction * __SPEED
