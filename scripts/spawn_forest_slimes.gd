extends Node2D

func _ready() -> void:
	("Slimes::_ready")
	if MysteryForestAutoload.has_initially_talked_with_monk_1():
		_on_initial_talk()
	else:
		MysteryForestAutoload.monk_1_initial_talk_signal.connect(_on_initial_talk)


func _on_initial_talk() -> void:
	("Slimes::_on_initial_talk")
	_spawn_slimes()


func _spawn_slimes() -> void:
	("Slimes::_spawn_slimes")
	var slime_prefab := preload("res://scenes/slime.tscn")
	
	const slime_positions : Array[Vector2] = [
		Vector2i(680, 3040), Vector2i(736, 3048),
		Vector2i(672, 3088), Vector2i(720, 3112),
		Vector2i(784, 3128)
	]
	
	for i in slime_positions.size():
		var slime : Slime = slime_prefab.instantiate()
		slime.name = "Slime%d" % (i + 1)
		slime.global_position = slime_positions[i]
		add_child(slime)

