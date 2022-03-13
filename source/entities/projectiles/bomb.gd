class_name Bomb extends Node2D


# Private variables

onready var __collider_area: Area2D = $collider_area
onready var __sprite: Sprite = $sprite

var __bodies: Array = []


# Lifecycle menthods

func _ready() -> void:
	__collider_area.connect("body_entered", self, "__add")
	__collider_area.connect("body_exited", self, "__remove")

	for time in [0.3, 0.2, 0.1]:
		for i in 6:
			var color: Color = Color.white if i % 2 == 0 else Color.transparent
			__sprite.material.set_shader_param("blend_color", color)

			yield(get_tree().create_timer(time), "timeout")

	for body in __bodies:
		if body.has_method("damage"):
			body.damage()

	queue_free()


# Private methods

func __add(body: Node2D) -> void:
	__bodies.append(body)


func __remove(body: Node2D) -> void:
	var index: int = __bodies.find(body)
	if index != -1:
		__bodies.remove(index)
