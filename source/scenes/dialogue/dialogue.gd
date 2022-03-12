extends Node

signal skipText

export(String, FILE, "*.json") var dialogueJson
export(NodePath) var AnimatorPath = "dialogue_box/background/text_margins/text/text_animator"
export(NodePath) var DialogueTextPath = "dialogue_box/background/text_margins/text"
export(NodePath) var SpeakerNamePath = "dialogue_box/background/speaker_label"

onready var Animator = get_node(AnimatorPath)
onready var DialogueText = get_node(DialogueTextPath)
onready var SpeakerName = get_node(SpeakerNamePath)

var dialogue_tree

var sentenceCount : int = 0

func _ready() -> void:
	var JsonData = File.new()
	JsonData.open(dialogueJson, JsonData.READ)
	dialogue_tree = JSON.parse(JsonData.get_as_text()).result.conversation
	parse_dialogue()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("skip_text"):
		emit_signal("skipText")
		

func parse_dialogue() -> void:
	for sentence in dialogue_tree:
		SpeakerName.bbcode_text = sentence.speaker
		DialogueText.bbcode_text = sentence.lines
		Animator.play("text_display")
		yield(self, "skipText")
		if !DialogueText.visible_characters == -1:
			Animator.stop()
			DialogueText.percent_visible = 1
			yield(self, "skipText")
#	yield(self, "skipText")
	self.call_deferred("queue_free")
