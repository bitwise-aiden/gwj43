extends KinematicBody2D

export (PackedScene) var attack_one

onready var player = get_parent()
onready var player_pos = player.position

onready var sprite = get_node("Sprite")

onready var sprite_attack_one = preload("res://assets/sprites/pets/shark_attack_one.png")
onready var sprite_scale_one = 0.3

onready var attacks = [attack_one]
onready var attack_data = {1: [sprite_attack_one, sprite_scale_one]}

var rotation_angle = 3 * (PI/4)


func _process(delta):
	if Input.is_action_just_pressed("attack_one"):
		shoot(1)
	movement(delta)
		
func movement(delta):
	position = player_pos + (position - player_pos).rotated(rotation_angle * delta)
		
func shoot(attack_number):
	var projectile = attacks[attack_number - 1].instance()
	owner.add_child(projectile)
	projectile.sprite.set_texture(attack_data[attack_number][0])
	projectile.set_scale(attack_data[attack_number][1])
	projectile.transform = get_node("projectile_spawn").global_transform
