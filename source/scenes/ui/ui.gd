extends MarginContainer


onready var hp_container : ProgressBar = $"main_container/ProgressBar"
onready var __tween : Tween = Tween.new()


var test = 1

func _ready() -> void:
	add_child(__tween)
	Event.connect("hp_change", self, "__change_hp")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("skip_text"):
		__change_hp(100.0, 100.0 - test * 10.0)
		test += 1

func __change_hp(max_hp : float, current_hp : float) -> void:
	hp_container.max_value = max_hp
	var current_value = hp_container.value
		
	# Change color
	__tween.interpolate_property(
				hp_container,
				"self_modulate",
				Color("ffffff"),
				Color("ff0000"),
				0.2,
				Tween.TRANS_LINEAR,
				Tween.EASE_OUT,
				0.0)
	# Change color back
	__tween.interpolate_property(
				hp_container,
				"self_modulate",
				Color("ff0000"),
				Color("ffffff"),
				0.2,
				Tween.TRANS_LINEAR,
				Tween.EASE_OUT,
				0.2)
	# Change value of bar
	__tween.interpolate_property(
				hp_container,
				"value",
				current_value,
				current_hp,
				1.0,
				Tween.TRANS_LINEAR,
				Tween.EASE_OUT,
				0.4)
	
	__tween.start()
