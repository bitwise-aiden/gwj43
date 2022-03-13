extends Node2D


# Public variables

export(Array, PackedScene) var dungeon_pool: Array


# Private variables

onready var __camera: GameCamera = $camera
onready var __dungeon_parent: Node2D = $dungeon_parent
onready var __player: Player = $player

var __dungeons: Dictionary = {
}

var __loaded_dungeons: Dictionary = {
	# key: Vector2
	# value: Dungeon
}

var __current_dungeon: Dungeon
var __dungeon_state: Dictionary = {
	# key: Vector2
	# value: Dictionary - state
}


# Lifecycle methods

func _ready() -> void:
	Event.connect("dungeon_changed", self, "__dungeon_changed")

	__camera.set_target(__player)

	__spawn_dungeons()


# Private methods

func __dungeon_changed(dungeon: Dungeon) -> void:
	if __current_dungeon:
		__dungeon_state[__current_dungeon.position_level] = __current_dungeon.exit()

	var dungeon_state: Dictionary = __dungeon_state.get(dungeon.position_level, {})
	__current_dungeon = dungeon
	__current_dungeon.enter(dungeon_state)

	__load_dungeons(dungeon.position_level)


func __get_neighbours(pos_current: Vector2) -> Array:
	var neighbours: Array = []

	for offset in [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT]:
		var pos_neighbour: Vector2 = pos_current + offset

		if __dungeons.has(pos_neighbour):
			neighbours.append(offset)

	return neighbours


func __load_dungeons(pos_current: Vector2) -> void:
	var to_load: Array = [pos_current]

	for pos_offset in __get_neighbours(pos_current):
		to_load.append(pos_current + pos_offset)

	var to_unload: Array = []

	for pos_dungeon in __loaded_dungeons:
		if to_load.find(pos_dungeon) == -1:
			to_unload.append(pos_dungeon)

	for pos_dungeon in to_unload:
		__loaded_dungeons[pos_dungeon].queue_free()
		__loaded_dungeons.erase(pos_dungeon)

	for pos_dungeon in to_load:
		if __loaded_dungeons.has(pos_dungeon):
			continue

		var dungeon_index: int = __dungeons[pos_dungeon]
		var instance: Dungeon = dungeon_pool[dungeon_index].instance()

		instance.position = pos_dungeon * Globals.DUNGEON_SIZE
		instance.position_level = pos_dungeon

		var neighbours: Array = __get_neighbours(pos_dungeon)
		instance.set_doors(neighbours)

		__loaded_dungeons[pos_dungeon] = instance
		__dungeon_parent.call_deferred("add_child", instance)


func __spawn_dungeons() -> void:
	for dungeon in __dungeon_parent.get_children():
		dungeon.queue_free()

	var generator: DungeonGenerator = DungeonGenerator.new(8, dungeon_pool.size())
	__dungeons = generator.generate()

	__load_dungeons(Vector2.ZERO)

#	for dungeon_position in __dungeons:
#		var dungeon: Dungeon = dungeon_pool[__dungeons[dungeon_position]].instance()
#		dungeon.position = dungeon_position * Globals.DUNGEON_SIZE
#
#		dungeon.set_doors(__get_neighbours(dungeons, dungeon_position))
#
#		__dungeon_parent.add_child(dungeon)
