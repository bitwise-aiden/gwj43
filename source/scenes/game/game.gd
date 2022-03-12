extends Node2D


# Public variables

export(Array, PackedScene) var dungeon_pool: Array


# Private variables

onready var __camera: GameCamera = $camera
onready var __dungeon_parent: Node2D = $dungeon_parent
onready var __player: Player = $player


# Lifecycle methods

func _ready() -> void:
	__camera.set_target(__player)

	__spawn_dungeons()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		__spawn_dungeons()


# Private methods

func __check_on_grid(pos_current: Vector2) -> bool:
	return -4 <= pos_current.x && pos_current.x <= 4 && \
		-3 <= pos_current.y && pos_current.y <= 4


func __generate_dungeons(count: int) -> Dictionary:
	var dungeons: Dictionary = {
		# key: Vector2 - position in map
		# value: int - index in dungeon pool

		Vector2.ZERO: 0, # Seed spawn room
	}
	var end_dungeons: Array = []

	var queue: Array = [Vector2.ZERO]

	while !queue.empty() && dungeons.size() < count:
		var pos_current: Vector2 = queue.pop_front()

		var added: bool = false

		for offset in [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT]:
			var pos_neighbour: Vector2 = pos_current + offset

			if !__check_on_grid(pos_neighbour):
				continue

			if dungeons.has(pos_neighbour):
				continue

			if __get_neighbour_count(dungeons, pos_neighbour) > 1:
				continue

			if dungeons.size() == count:
				continue

			if randi() % 2 == 0 && pos_neighbour != Vector2.ZERO:
				continue

			dungeons[pos_neighbour] = randi() % dungeon_pool.size()
			queue.append(pos_neighbour)
			added = true

		if !added:
			end_dungeons.append(pos_current)

	return dungeons


func __get_neighbour_count(dungeons: Dictionary, pos_current: Vector2) -> int:
	var count: int = 0

	for offset in [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT]:
		var pos_neighbour: Vector2 = pos_current + offset

		if dungeons.has(pos_neighbour):
			count += 1

	return count


func __spawn_dungeons() -> void:
	for dungeon in __dungeon_parent.get_children():
		dungeon.queue_free()

	var dungeons: Dictionary = {}

	while dungeons.size() < 8:
		dungeons = __generate_dungeons(8)

	for dungeon_position in dungeons:
		var dungeon: Dungeon = dungeon_pool[dungeons[dungeon_position]].instance()
		dungeon.position = dungeon_position * Globals.DUNGEON_SIZE

		dungeon.modulate = Color(randf(), randf(), randf())

		__dungeon_parent.add_child(dungeon)
