class_name Enemy extends KinematicBody2D


# Public signals

signal died(enemy)


# Public variables

var spawner_id: int = -1


# Protected variables

onready var _sprite: Sprite = $sprite

var _health: int
var _spawned: bool = false

var _cooldown_attack: float = 0.0

var _tween: Tween = Tween.new()


# Lifecycle methods

func _ready() -> void:
	add_child(_tween)


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

	_sprite.material.set_shader_param("blend_color", Color.red)

	yield(get_tree().create_timer(0.1), "timeout")

	for i in 6:
		var color: Color = Color.white if i % 2 == 0 else Color.transparent
		_sprite.material.set_shader_param("blend_color", color)

		yield(get_tree().create_timer(0.05), "timeout")

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

