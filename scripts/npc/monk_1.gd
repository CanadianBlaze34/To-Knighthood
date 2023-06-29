extends NPC


@onready var dialogue_area: DialogueAction = $DialogueArea


func _ready() -> void:
	print("Monk1::_ready")
	if MysteryForestAutoload.has_initially_talked_with_monk_1():
		_on_initial_talk()
		if MysteryForestAutoload.has_monk_1_quest_complete():
			queue_free()
		else:
			MysteryForestAutoload.monk_1_quest_complete.connect(queue_free)
	else:
		MysteryForestAutoload.monk_1_initial_talk_signal.connect(_on_initial_talk)


func _on_initial_talk() -> void:
	dialogue_area.start_automatic = false
