class_name GameCamera extends Camera2D


# Private variable

var __target: Node2D = null


# Lifecycle methods

func _ready() -> void:
	make_current()


func _process(delta: float) -> void:
	position = __target.position


# Public methods

func set_target(target: Node2D) -> void:
	__target = target
