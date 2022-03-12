extends VBoxContainer

# Public variables
var current_delay : float = 0.5
var delay_step : float = 0.5

# Private variables
var __button_scene : PackedScene = preload("res://source/menus/components/button_change_scene.tscn")

var __list_of_buttons : Array = ["play", "settings", "credits", "exit"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for name in __list_of_buttons:
		var new_button = __button_scene.instance()
		new_button.name = "button_" + name
		new_button.delay = current_delay
		new_button.visible = false
		self.call_deferred("add_child", new_button)
		current_delay += delay_step

