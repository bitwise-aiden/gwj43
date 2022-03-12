class_name Dungeon extends Node2D


# Public variables

var bounds: Rect2 setget , __bounds_get

# Private variables

onready var __collider_area: Area2D = $collider_area


# Lifecylce methods

func _ready() -> void:
	__collider_area.connect("body_entered", self, "__body_entered")


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
