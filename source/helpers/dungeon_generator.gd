class_name DungeonGenerator


# Private variables

var __size: int = 0
var __pool_size: int = 0

var __dungeons: Dictionary = {}
var __end_dungeons: Array = []
var __queue: Array = []


# Lifecycle methods

func _init(size: int, pool_size: int) -> void:
	__pool_size = pool_size
	__size = size


func generate() -> Dictionary:
	var completed_dungeon: Dictionary = {}

	while completed_dungeon.size() < __size:
		__queue = [Vector2.ZERO]
		__dungeons = {Vector2.ZERO: 0}

		__generate()

		completed_dungeon = __dungeons.duplicate()

	__dungeons.clear()

	return completed_dungeon


# Private methods


func __generate() -> void:
	while !__queue.empty() && __dungeons.size() < __size:
		var pos_current: Vector2 = __queue.pop_front()

		var added: bool = false

		for offset in [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT]:
			added = __visit(pos_current + offset) || added

		if !added:
			__end_dungeons.append(pos_current)


func __get_neighbour_count(pos_current: Vector2) -> int:
	var count: int = 0

	for offset in [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT]:
		var pos_neighbour: Vector2 = pos_current + offset

		if __dungeons.has(pos_neighbour):
			count += 1

	return count


func __check_on_grid(pos_current: Vector2) -> bool:
	return -4 <= pos_current.x && pos_current.x <= 4 && \
		-3 <= pos_current.y && pos_current.y <= 4


func __visit(pos_current: Vector2) -> bool:
	if !__check_on_grid(pos_current):
		return false

	if __dungeons.has(pos_current):
		return false

	if __get_neighbour_count(pos_current) > 1:
		return false

	if __dungeons.size() == __size:
		return false

	if randi() % 2 == 0 && pos_current != Vector2.ZERO:
		return false

	__dungeons[pos_current] = randi() % __pool_size
	__queue.append(pos_current)

	return true
