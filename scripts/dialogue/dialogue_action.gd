class_name DialogueAction extends Area2D

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = ""
@export var start_automatic : bool = false
@export var emit_finished_on_dialogue_end : bool = true

func play() -> void:
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
