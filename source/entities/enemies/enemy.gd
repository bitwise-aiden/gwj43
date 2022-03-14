class_name Enemy extends KinematicBody2D


# Public signals

signal died(enemy)


# Public variables

var spawner_id: int = -1


# Protected variables

var _health: int
var _spawned: bool = false

var _cooldown_attack: float = 0.0


# Lifecycle methods

func _physics_process(delta: float) -> void:
	if !_spawned:
		return

	if _cooldown_attack > 0.0:
		_cooldown_attack = max(0.0, _cooldown_attack - delta)
	else:
		_attack(delta)

	_move(delta)


# Public methods

func damage() -> void:
	_health -= 1

	if _health == 0:
		var result: GDScriptFunctionState = _died()
		if result:
			yield(result, "completed")

		emit_signal("died", self)
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

