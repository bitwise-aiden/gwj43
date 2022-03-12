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
	var dungeon: Dungeon = dungeon_pool[randi() % dungeon_pool.size()].instance()

	dungeon.modulate = Color("#1F2337")

	add_child(dungeon)
