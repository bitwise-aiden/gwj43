extends Control

# Private variables
onready var __animation_player : AnimationPlayer = $"AnimationPlayer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	__animation_player.play("card_bounce")

