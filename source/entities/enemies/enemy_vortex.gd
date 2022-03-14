class_name EnemyVortex extends Enemy

# Private constants

const __COOLDOWN_ATTACK: float = 2.0
const __HEALTH: int = 3


# Private variables

onready var __collider_target: Area2D = $collider_target
onready var __sprite: Sprite = $sprite
onready var __initial_scale: Vector2 = scale

var __target: Node2D


# Lifecycle methods

func _ready() -> void:
	_health = __HEALTH

	__collider_target.connect("body_entered", self, "__target_add")
	__collider_target.connect("body_exited", self, "__target_remove")
	# I like shorts! They're comfy, and easy to wear. - Daverinoe
	_tween.interpolate_property(
		self,
		"scale",
		Vector2.ZERO,
		__initial_scale,
		0.5
	)

	_tween.start()

	yield(_tween, "tween_completed")

	_spawned = true


func _process(delta: float) -> void:
	__sprite.rotation += delta * 2.0


# Protected methods

func _attack(delta: float) -> void:
	if !__target:
		return

	_cooldown_attack = __COOLDOWN_ATTACK

	var target_direction: Vector2 = (__target.global_position - global_position).normalized()

	for i in 3:
		ProjectileSpawner.spawn_projectile_vortex(global_position, target_direction)

		yield(get_tree().create_timer(0.3), "timeout")


func _damaged() -> void:
	pass


func _died() -> void:
	_spawned = false

	_tween.interpolate_property(
		self,
		"scale",
		__initial_scale,
		Vector2.ZERO,
		0.5
	)

	_tween.start()

	yield(_tween, "tween_completed")


func _move(delta: float) -> void:
	pass # No move


# Private variables

func __target_add(body: Node2D) -> void:
	if body is Player:
		__target = body


func __target_remove(body: Node2D) -> void:
	if body is Player:
		__target = null
