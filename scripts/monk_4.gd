extends NPC

@onready var dialogue_area: DialogueAction = $DialogueArea


func _ready() -> void:
	print("Monk4::_ready")
	if MysteryForestAutoload.is_first_time_talking_with_monk_4():
		_on_initial_talk()
	else:
		MysteryForestAutoload.talked_with_monk_4_for_the_first_time_signal\
			.connect(_on_initial_talk, CONNECT_ONE_SHOT)


func _on_initial_talk() -> void:
	dialogue_area.start_automatic = false
