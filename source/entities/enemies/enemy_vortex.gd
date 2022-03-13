class_name EnemyVortex extends Enemy


# Private variables

var __tween: Tween = Tween.new()


# Lifecycle methods

func _ready() -> void:
	add_child(__tween)

	__tween.interpolate_property(
		self,
		"scale",
		Vector2.ZERO,
		scale,
		0.5
	)

	__tween.start()

	yield(__tween, "tween_completed")

	_spawned = true


func _process(delta: float) -> void:
	rotation += delta * 2.0


# Protected methods

func _attack(delta: float) -> void:
	pass


func _damaged() -> void:
	pass


func _died() -> void:
	pass


func _move(delta: float) -> void:
	pass # No move
