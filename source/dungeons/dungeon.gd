class_name Dungeon extends Node2D


# Public variables

var bounds: Rect2 setget , __bounds_get


# Private variables

onready var __collider_area: Area2D = $collider_area
onready var __door_colliders: Dictionary = {
	Vector2.LEFT: $collider_doors/left,
	Vector2.RIGHT: $collider_doors/right,
	Vector2.UP: $collider_doors/up,
	Vector2.DOWN: $collider_doors/down,
}

var __active_doors: Array = []


# Lifecylce methods

func _ready() -> void:
	__collider_area.connect("body_entered", self, "__body_entered")

	door_unlock()


# Public methods

func doors_lock() -> void:
	for door in __door_colliders:
		__door_colliders[door].disabled = false


func door_unlock() -> void:
	for door in __door_colliders:
		__door_colliders[door].disabled = __active_doors.find(door) != -1


func set_doors(doors: Array) -> void:
	__active_doors = doors
	print(__active_doors)


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
