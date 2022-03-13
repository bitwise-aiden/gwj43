extends Node2D


# Private variables

onready var __animation: AnimationPlayer = $animation
onready var __collider_area: Area2D = $collider_area
onready var __collider_mover: Area2D = $collider_mover

var __type: PickUpType
var __target: Node2D


# Lifecycle methods

func _ready() -> void:
	__collider_area.connect("body_entered", self, "__pick_up")

	__collider_mover.connect("body_entered", self, "__target", [true])
	__collider_mover.connect("body_exited", self, "__target", [false])

	__animation.play("idle")


func _process(delta):
	if !__target:
		return

	var distance: float = 64.0 - position.distance_to(__target.position)
	var damping: float = clamp(distance * distance * delta * 0.05, 0.5, 1.0)

	position = position.move_toward(__target.position, delta * 500.0 * damping)


# Private methods

func __pick_up(body: Node2D) -> void:
	if body is Player:
		yield(get_tree().create_timer(0.1), "timeout")

		if __target:
			queue_free()


func __target(body: Node2D, follow: bool) -> void:
	if body is Player:
		if follow:
			__target = body
			__animation.stop()
		else:
			__target = null
			__animation.play("idle")
