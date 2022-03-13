class_name Enemy extends KinematicBody2D


# Protected variables

var _health: int
var _spawned: bool = false


# Lifecycle methods

func _physics_process(delta: float) -> void:
	if !_spawned:
		return

	_attack(delta)
	_move(delta)


# Public methods

func damage() -> void:
	_health -= 1

	if _health == 0:
		_died()

		Event.emit_signal("enemy_died", self)
		queue_free()
	else:
		_damaged()


# Protected methods

func _attack(delta: float) -> void:
	pass


func _damaged() -> void:
	pass


func _died() -> void:
	pass


func _move(delta: float) -> void:
	pass

