class_name OverWorldTilemap extends TileMap

func _ready() -> void:
	Village1.permission_granted_to_leave_town.connect(_remove_village_1_invisible_barrier)

func _remove_village_1_invisible_barrier() -> void:
	print("overworldtilemap._remove_village_1_invisible_barrier")
	const wall_layer : int = 4
	erase_cell(wall_layer, Vector2i(99, 170))
	erase_cell(wall_layer, Vector2i(100, 170))
