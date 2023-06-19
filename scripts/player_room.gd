class_name PlayerRoom extends Room


func _ready() -> void:
	# prevents circular(cyclic) dependacy null error
	var over_world_scene : PackedScene = load("res://scenes/over_world.tscn")
	transition.scene = over_world_scene
