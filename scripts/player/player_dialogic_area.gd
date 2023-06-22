class_name PlayerDialogueArea extends Area2D

var _npc_dialogue : DialogueAction
var in_dialogue : bool = false

signal dialogue_state(state : bool)

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)


func _on_dialogue_ended(resource) -> void:
	if _npc_dialogue and resource == _npc_dialogue.dialogue_resource:
		print("finished dialogue")
		in_dialogue = false
		dialogue_state.emit(in_dialogue)
		
		if _npc_dialogue.start_automatic:
			_npc_dialogue = null


func _input(event: InputEvent) -> void:
	# play the dialogue of an npc if an npc is close
	
	# currently speaking or
	# isn't near a npc to speak with
	if in_dialogue or not _npc_dialogue:
		return
	
	if event.is_action_pressed("ui_accept"):
		_play_dialogue()


func _play_dialogue() -> void:
	_npc_dialogue.play()
	in_dialogue = true
	dialogue_state.emit(in_dialogue)


func _on_area_entered(area: Area2D) -> void:
	print("can  talk to %s." % [area.get_parent().name])
	_npc_dialogue = area as DialogueAction
	if _npc_dialogue.start_automatic:
		_play_dialogue()


func _on_area_exited(area: Area2D) -> void:
	print("cant talk to %s." % [area.get_parent().name])
	if area == _npc_dialogue:
		_npc_dialogue = null 

