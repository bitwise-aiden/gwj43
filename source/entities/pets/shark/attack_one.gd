extends Node2D

onready var sprite = get_node("Sprite")

var speed = 100

func _physics_process(delta):
	position += transform.x * speed * delta

func set_scale(scale):
	sprite.scale = Vector2(scale, scale)

func _on_projectile_body_entered(body):
	if body.is_in_group("mobs"):
		body.queue_free()
