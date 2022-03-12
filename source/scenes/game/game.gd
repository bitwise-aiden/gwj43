extends Node2D


# Public variables

export(Array, PackedScene) var dungeon_pool: Array


# Private variables

onready var __camera: GameCamera = $camera
onready var __player: Player = $player


# Lifecycle methods

func _ready() -> void:
	__camera.set_target(__player)

	__spawn_rooms()


# Private methods

func __spawn_rooms() -> void:
	var positions: Array = [
		Vector2.ZERO,
		Vector2.UP,
		Vector2.DOWN,
		Vector2.LEFT,
		Vector2.RIGHT
	]

	for dungeon_position in positions:
		var dungeon: Dungeon = dungeon_pool[randi() % dungeon_pool.size()].instance()
		dungeon.position = dungeon_position * Globals.DUNGEON_SIZE

		dungeon.modulate = Color(randf(), randf(), randf())

		add_child(dungeon)
