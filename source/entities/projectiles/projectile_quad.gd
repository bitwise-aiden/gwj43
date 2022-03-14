class_name ProjectileQuad extends Projectile


# Private constants

const __SPEED: float = 10.0


# Private variables

onready var __sprite: Sprite = $sprite


# Lifecycle methods

func _ready() -> void:
	__sprite.rotation = _direction.angle() + PI * 0.5


# Protected methods

func _calculated_velocity(delta: float) -> Vector2:
	return _direction * __SPEED
