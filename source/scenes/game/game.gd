extends Node2D


# Public variables

export(Array, PackedScene) var dungeon_pool: Array


# Private variables

onready var __camera: GameCamera = $camera
onready var __dungeon_parent: Node2D = $dungeon_parent
onready var __player: Player = $player


# Lifecycle methods

func _ready() -> void:
	Event.connect("dungeon_changed", self, "__dungeon_changed")

	__camera.set_target(__player)

	__spawn_dungeons()


# Private methods

func __dugeon_changed(dungeon: Dungeon) -> void:
	pass

func __get_neighbours(dungeons: Dictionary, pos_current: Vector2) -> Array:
	var neighbours: Array = []

	for offset in [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT]:
		var pos_neighbour: Vector2 = pos_current + offset

		if dungeons.has(pos_neighbour):
			neighbours.append(offset)

	return neighbours


func __spawn_dungeons() -> void:
	for dungeon in __dungeon_parent.get_children():
		dungeon.queue_free()

	var generator: DungeonGenerator = DungeonGenerator.new(8, dungeon_pool.size())
	var dungeons: Dictionary = generator.generate()

	for dungeon_position in dungeons:
		var dungeon: Dungeon = dungeon_pool[dungeons[dungeon_position]].instance()
		dungeon.position = dungeon_position * Globals.DUNGEON_SIZE

		dungeon.set_doors(__get_neighbours(dungeons, dungeon_position))

		__dungeon_parent.add_child(dungeon)
