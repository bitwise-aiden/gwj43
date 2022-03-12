extends TextureButton


export (String) var scene_name

# Private variables
var __tween = Tween.new()
var __button_start : float = -500.0
var duration : float = 1.5
var delay : float = 0.0

# Lifecycle methods
func _ready() -> void:
	add_child(__tween)
	__set_texture()
	self.connect("button_up", SceneManager, "load_scene", [self.scene_name])
	move_button("in")

func move_button(direction : String) -> void:
	match direction:
		"in":
			__tween.interpolate_property(
				self,
				"rect_position:x",
				__button_start,
				500.0,
				duration,
				Tween.TRANS_BOUNCE,
				Tween.EASE_IN_OUT,
				delay
			)
		"out":
			__tween.interpolate_property(
				self,
				"rect_position:x",
				500.0,
				__button_start,
				duration,
				Tween.TRANS_BOUNCE,
				Tween.EASE_IN_OUT,
				delay
			)
	__tween.start()
	self.visible = true

func __set_texture() -> void:
	match self.name:
		"button_play":
			self.texture_normal = load("res://assets/sprites/menu/play.png")
		"button_settings":
			self.texture_normal = load("res://assets/sprites/menu/settings.png")
		"button_credits":
			self.texture_normal = load("res://assets/sprites/menu/credits.png")
		"button_exit":
			self.texture_normal = load("res://assets/sprites/menu/quit.png")
