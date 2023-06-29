class_name OverWorldTilemap extends TileMap

const _ground_layer : int = 0
const _trees_layer : int = 1

func _ready() -> void:
	_set_up_saved_data()


func _set_up_saved_data() -> void:
	if Village1Autoload.has_grant_permission_to_leave_town():
		_on_permission_to_leave_town()
	else:
		Village1Autoload.permission_granted_to_leave_town.connect(_on_permission_to_leave_town)
	
	if MysteryForestAutoload.has_initially_talked_with_monk_1():
		_on_monk_1_initial_talk_signal()
	else:
		MysteryForestAutoload.monk_1_initial_talk_signal.connect(_on_monk_1_initial_talk_signal)


func _on_permission_to_leave_town() -> void:
	_remove_village_1_invisible_barrier()


func _remove_village_1_invisible_barrier() -> void:
	print("overworldtilemap._remove_village_1_invisible_barrier")
	const wall_layer : int = 4
	erase_cell(wall_layer, Vector2i(99, 170))
	erase_cell(wall_layer, Vector2i(100, 170))


func _on_monk_1_initial_talk_signal()-> void:
	_open_first_path()

func _open_first_path() -> void:
	print("OverWorldTilemap::_open_first_path")
	# spawn forest grass
	const grass_positions : Array[Vector2i] = [
		Vector2i(46, 183), Vector2i(47, 183),
		Vector2i(46, 184), Vector2i(47, 184),
		Vector2i(46, 185), Vector2i(47, 185),
		Vector2i(46, 186), Vector2i(47, 186),
		Vector2i(46, 187), Vector2i(47, 187),
		Vector2i(46, 188), Vector2i(47, 188)
	]
	for grass_position in grass_positions:
		_spawn_forest_grass(grass_position)
	
	
	# remove forest trees
	const remove_trees_positions : Array[Vector2i] = [
		Vector2i(46, 183), Vector2i(47, 183),
		Vector2i(46, 184), Vector2i(47, 184),
		Vector2i(46, 187), Vector2i(47, 187),
		Vector2i(46, 188), Vector2i(47, 188)
	]
	
	for tree_position in remove_trees_positions:
		erase_cell(_trees_layer, tree_position)
	
	
	# spawn forest trees
	const spawn_trees_positions : Array[Vector2i] = [
		Vector2i(44, 185), Vector2i(45, 185), Vector2i(48, 185), Vector2i(49, 185),
		Vector2i(44, 186), Vector2i(45, 186), Vector2i(48, 186), Vector2i(49, 186)
	]
	
	for tree_position in spawn_trees_positions:
		_spawn_forest_trees(tree_position)


func _spawn_forest_grass(coords : Vector2i) -> void:
	const ground_source_id : int = 0
	const forest_grass_atlas_coords := Vector2i(11, 12)
	const default_alternative : int = 0
	set_cell(_ground_layer, coords, ground_source_id, forest_grass_atlas_coords, default_alternative)


func _spawn_forest_trees(coords : Vector2i) -> void:
	const nature_source_id : int = 2
	const forest_grass_atlas_coords := Vector2i(6, 0)
	const default_alternative : int = 0
	set_cell(_trees_layer, coords, nature_source_id, forest_grass_atlas_coords, default_alternative)









