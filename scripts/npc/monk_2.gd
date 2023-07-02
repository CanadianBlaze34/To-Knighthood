extends NPC

@onready var dialogue_area: DialogueAction = $DialogueArea


func _ready() -> void:
	print("Monk2::_ready")
	if MysteryForestAutoload.is_first_time_talking_with_monk_2():
		_on_initial_talk()
	else:
		MysteryForestAutoload.talked_with_monk_2_for_the_first_time_signal\
			.connect(_on_initial_talk, CONNECT_ONE_SHOT)
	
	if MysteryForestAutoload.is_monk_2_quest_completed():
		queue_free()
	else:
		MysteryForestAutoload.monk_2_quest_complete\
			.connect(queue_free, CONNECT_ONE_SHOT)


func _on_initial_talk() -> void:
	dialogue_area.start_automatic = false
