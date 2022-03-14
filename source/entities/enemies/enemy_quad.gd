class_name EnemyQuad extends Enemy


# Private constants

const __HEALTH: int = 3


# Private methods

onready var __projectile_spawn: Array = $projectile_spawn_parent.get_children()
onready var __initial_scale: Vector2 = scale

var __time_elapsed: float = 0.0
var __tween: Tween = Tween.new()


# Lifecycle methods

func _ready() -> void:
	add_child(__tween)

	_health = __HEALTH

	__tween.interpolate_property(
		self,
		"scale",
		Vector2.ZERO,
		__initial_scale,
		0.5
	)



	__tween.interpolate_property(
		self,
		"rotation_degrees",
		0.0,
		1440.0,
		0.5
	)

	__tween.start()

	yield(__tween, "tween_all_completed")

	_spawned = true


func _physics_process(delta) -> void:
	__time_elapsed += delta * 23.0
	scale = __initial_scale + Vector2(sin(__time_elapsed), sin(__time_elapsed)) * 0.01


# Protected methods

func _attack(delta: float) -> void:
	_cooldown_attack = 3.0

	var scales: Array = [__initial_scale, __initial_scale * 0.75]

	for i in 6:
		__tween.interpolate_property(
			self,
			"scale",
			scales[0],
			scales[1],
			0.1
		)
		__tween.start()

		yield(__tween, "tween_completed")

		scales.invert()

		for spawn in __projectile_spawn:
			ProjectileSpawner.spawn_projectile_quad(
				spawn.position + position,
				Vector2.UP.rotated(spawn.rotation)
			)


func _damaged() -> void:
	pass


func _died() -> void:
	pass


func _move(delta: float) -> void:
	pass

