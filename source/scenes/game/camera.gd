class_name GameCamera extends Camera2D


# Private variable

var __bounds_dungeon: Rect2 = Rect2(
	Vector2.ZERO,
	Vector2(2560.0, 1408.0)
)
var __bounds_target: Rect2 = Rect2(
	Vector2.ZERO,
	Vector2(640.0, 360.0)
)

var __target: Node2D = null

var __closest_point: Vector2 = Vector2.ZERO
var __move_target: Vector2 = Vector2.ZERO


# Lifecycle methods

func _ready() -> void:
	make_current()

	__bounds_dungeon.position -= __bounds_dungeon.size * 0.5

	Event.connect("dungeon_bounds_changed", self, "set_bounds_dungeon")


func _process(delta: float) -> void:
	var pos_target: Vector2 = __target.global_position
	var pos_camera: Vector2 = global_position

	__bounds_target.position = pos_camera - __bounds_target.size * 0.5

	__closest_point = __calculate_closest_point(__bounds_target, pos_target)

	__move_target = pos_camera
	__move_target += pos_target - __closest_point
	__move_target = __calculate_closest_point(__bounds_dungeon, __move_target)

	var distance: float = pos_camera.distance_to(__closest_point) + 0.5
	var damping: float = clamp(distance * distance * 0.05, 0.01, 1.0)

	global_position = pos_camera.move_toward(__move_target, delta * 1750.0 * damping)


# Public methods

func set_bounds_dungeon(bounds: Rect2) -> void:
	__bounds_dungeon = bounds
	__bounds_dungeon.position += Globals.SCREEN_SIZE * 0.5
	__bounds_dungeon.size -= Globals.SCREEN_SIZE


func set_target(target: Node2D) -> void:
	__target = target


# Private methods

func __calculate_closest_point(rect: Rect2, target: Vector2) -> Vector2:
	if rect.has_point(target):
		return target

	var pos_tl: Vector2 = rect.position
	var pos_tr: Vector2 = rect.position + Vector2.RIGHT * rect.size.x
	var pos_bl: Vector2 = rect.position + Vector2.DOWN * rect.size.y
	var pos_br: Vector2 = rect.position + rect.size

	var points: Array = [
		Geometry.get_closest_point_to_segment_2d(target, pos_tl, pos_tr),
		Geometry.get_closest_point_to_segment_2d(target, pos_tr, pos_br),
		Geometry.get_closest_point_to_segment_2d(target, pos_br, pos_bl),
		Geometry.get_closest_point_to_segment_2d(target, pos_bl, pos_tl),
	]

	var closest: Vector2 = Vector2.INF

	for point in points:
		if target.distance_to(point) < target.distance_to(closest):
			closest = point

	return closest
