class_name Dungeon extends Node2D


# Public variables

var bounds: Rect2 setget , __bounds_get

var position_level: Vector2


# Private variables

onready var __collider_area: Area2D = $collider_area
onready var __door_colliders: Dictionary = {
	Vector2.LEFT: $collider_doors/left,
	Vector2.RIGHT: $collider_doors/right,
	Vector2.UP: $collider_doors/up,
	Vector2.DOWN: $collider_doors/down,
}
onready var __enemy_parent: Node2D = $enemy_parent
onready var __enemy_spawners: Array = $enemy_spawner_parent.get_children()
onready var __fade: ColorRect = $fade/rect
onready var __overlay: Sprite = $overlay
onready var __projectile_parent: Node2D = $projectile_parent

var __tween: Tween = Tween.new()

var __player: Player

var __active_doors: Array = []
var __state: Dictionary = {
	"inactive_spawners": []
}


# Lifecylce methods

func _ready() -> void:
	add_child(__tween)

	__collider_area.connect("body_entered", self, "__body_entered")

	door_unlock()


func _process(delta: float) -> void:
	if __player:
		__overlay.material.set_shader_param("player", __player.global_position + Globals.SCREEN_SIZE - position)


# Public methods

func add_projectile(projectile: Node2D) -> void:
	__projectile_parent.call_deferred("add_child", projectile)


func add_enemy(enemy: Enemy) -> void:
	__enemy_parent.call_deferred("add_child", enemy)


func doors_lock() -> void:
	for door in __door_colliders:
		__door_colliders[door].disabled = false


func door_unlock() -> void:
	for door in __door_colliders:
		__door_colliders[door].disabled = __active_doors.find(door) != -1


func enter(state: Dictionary) -> void:
	__tween.interpolate_property(
		__fade,
		"color:a",
		1.0,
		0.0,
		0.2
	)

	__tween.start()
	yield(__tween, "tween_completed")

	if state:
		__state = state

	var inactive_spawners: Array = __state.get("inactive_spawners", [])
	for spawner_index in __enemy_spawners.size():
		if inactive_spawners.find(spawner_index) == -1:
			var instance: Enemy = __enemy_spawners[spawner_index].spawn()
			instance.spawner_id = spawner_index

			instance.connect("died", self, "__enemy_died")

			add_enemy(instance)


func exit() -> Dictionary:
	__exit()

	return __state


func set_doors(doors: Array) -> void:
	__active_doors = doors


# Private methods

func __bounds_get() -> Rect2:
	var size: Vector2 = Globals.DUNGEON_SIZE

	return Rect2(
		position - size * 0.5,
		size
	)


func __body_entered(body: Node) -> void:
	if body is Player:
		Event.emit_signal("dungeon_changed", self)
		Event.emit_signal("dungeon_bounds_changed", self.bounds)

		__player = body


func __enemy_died(enemy: Enemy) -> void:
	__state["inactive_spawners"].append(enemy.spawner_id)


func __exit() -> void:
	__player = null

	__tween.interpolate_property(
		__fade,
		"color:a",
		0.0,
		1.0,
		0.2
	)

	__tween.start()
	yield(__tween, "tween_completed")

	for projectile in __projectile_parent.get_children():
		projectile.queue_free()

	for enemy in __enemy_parent.get_children():
		enemy.queue_free()

