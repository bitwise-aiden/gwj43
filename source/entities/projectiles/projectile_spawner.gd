extends Node

# Private constants

const __BOMB: Resource = preload("res://source/entities/projectiles/bomb.tscn")


# Private variables

var __target_dungeon: Dungeon


# Lifecycle methods

func _ready() -> void:
	Event.connect("dungeon_changed", self, "__dungeon_changed")


# Public methods

func spawn_bomb(position: Vector2) -> bool:
	if !__target_dungeon:
		return false

	var instance: Bomb = __BOMB.instance()
	instance.position = position

	__target_dungeon.add_projectile(instance)

	return true


# Private methods

func __dungeon_changed(dungeon: Dungeon) -> void:
	__target_dungeon = dungeon

