class_name DialogueAction extends Area2D

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = ""
@export var start_automatic : bool = false

func play() -> void:
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
