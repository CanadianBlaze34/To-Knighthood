class_name OverWorldTilemap extends TileMap

const _ground_layer : int = 0
const _trees_layer : int = 1

func _ready() -> void:
	_set_up_saved_data()


func _set_up_saved_data() -> void:
	# Village gaurd
	if Village1Autoload.has_grant_permission_to_leave_town():
		_on_permission_to_leave_town()
	else:
		Village1Autoload.permission_granted_to_leave_town.connect(_on_permission_to_leave_town)
	
	# monk1
	if MysteryForestAutoload.has_initially_talked_with_monk_1():
		_on_monk_1_initial_talk_signal()
	else:
		MysteryForestAutoload.monk_1_initial_talk_signal.connect(_on_monk_1_initial_talk_signal)
	
	# monk2
	if MysteryForestAutoload.is_first_time_talking_with_monk_2():
		_remove_2nd_secret_passage_trees()
	else:
		MysteryForestAutoload.talked_with_monk_2_for_the_first_time_signal.connect(_remove_2nd_secret_passage_trees, CONNECT_ONE_SHOT)
	
	if MysteryForestAutoload.is_monk_2_quest_completed():
		_remove_monk_2_trees()
	else:
		MysteryForestAutoload.monk_2_quest_complete.connect(_remove_monk_2_trees, CONNECT_ONE_SHOT)
	
	# monk3
	if MysteryForestAutoload.is_first_time_talking_with_monk_3():
		_remove_3nd_secret_passage_trees()
	else:
		MysteryForestAutoload.talked_with_monk_3_for_the_first_time_signal.connect(_remove_3nd_secret_passage_trees, CONNECT_ONE_SHOT)
	
	if MysteryForestAutoload.is_monk_3_quest_completed():
		_remove_monk_3_trees()
	else:
		MysteryForestAutoload.monk_3_quest_complete.connect(_remove_monk_3_trees, CONNECT_ONE_SHOT)


# Village 1 --------------------------------------------------------------------

func _on_permission_to_leave_town() -> void:
	_remove_village_1_invisible_barrier()


func _remove_village_1_invisible_barrier() -> void:
	print("overworldtilemap._remove_village_1_invisible_barrier")
	const wall_layer : int = 4
	erase_cell(wall_layer, Vector2i(99, 170))
	erase_cell(wall_layer, Vector2i(100, 170))

# forest -----------------------------------------------------------------------

# Monk 1 -----------------------------------------------------------------------

func _on_monk_1_initial_talk_signal()-> void:
	_open_first_path()
	
	if MysteryForestAutoload.has_monk_1_quest_complete():
		_on_monk_1_quest_complete()
	else:
		MysteryForestAutoload.monk_1_quest_complete.connect(_on_monk_1_quest_complete)


func _on_monk_1_quest_complete() -> void:
	_remove_trees_behind_monk_1()


func _remove_trees_behind_monk_1() -> void:
	const tree_positions : PackedVector2Array = [
		Vector2i(15, 175), Vector2i(16, 175),
		Vector2i(17, 175), Vector2i(18, 175)
	]
	remove_trees(tree_positions)

# Monk 2 -----------------------------------------------------------------------

func _remove_monk_2_trees() -> void:
	const tree_positions : PackedVector2Array = [
		Vector2i(27, 151),
		Vector2i(27, 152),
		Vector2i(27, 153),
		Vector2i(27, 154)
	]
	remove_trees(tree_positions)


func _remove_2nd_secret_passage_trees() -> void:
	const tree_positions : PackedVector2Array = [
		Vector2i(39, 168), Vector2i(40, 168),
		Vector2i(39, 169), Vector2i(40, 169)
	]
	remove_trees(tree_positions)

# Monk 3 -----------------------------------------------------------------------

func _remove_monk_3_trees() -> void:
	const tree_positions : PackedVector2Array = [
		Vector2i(41, 141),
		Vector2i(41, 142),
		Vector2i(41, 143),
		Vector2i(41, 144)
	]
	remove_trees(tree_positions)


func _remove_3nd_secret_passage_trees() -> void:
	const tree_positions : PackedVector2Array = [
		Vector2i(7, 141), Vector2i(8, 141),
		Vector2i(7, 142), Vector2i(8, 142)
	]
	remove_trees(tree_positions)

# ------------------------------------------------------------------------------

func remove_trees(tree_positions : PackedVector2Array) -> void:
	for tree_position in tree_positions:
		remove_tree(tree_position)


func remove_tree(tree_position : Vector2i) -> void:
	erase_cell(_trees_layer, tree_position)


func add_forest_trees(tree_positions : PackedVector2Array) -> void:
	for tree_position in tree_positions:
		add_forest_tree(tree_position)


func add_forest_tree(tree_position : Vector2i) -> void:
	const nature_source_id : int = 2
	const forest_grass_atlas_coords := Vector2i(6, 0)
	const default_alternative : int = 0
	set_cell(_trees_layer, tree_position, nature_source_id, forest_grass_atlas_coords, default_alternative)


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
	const remove_trees_positions : PackedVector2Array = [
		Vector2i(46, 183), Vector2i(47, 183),
		Vector2i(46, 184), Vector2i(47, 184),
		Vector2i(46, 187), Vector2i(47, 187),
		Vector2i(46, 188), Vector2i(47, 188)
	]
	remove_trees(remove_trees_positions)
	
	
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









