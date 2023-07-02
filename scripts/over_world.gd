class_name OverWorld extends Node2D


@onready var over_world_tilemap: OverWorldTilemap = $OverWorldTilemap
@onready var _legendary_golden_raccoon_fight: LegendaryGoldenRaccoonFight = $MysteryForest/Events/LegendaryGoldenRaccoonFight
@onready var giant_gold_raccoon: GiantGoldenRaccoon = $MysteryForest/Monsters/GiantGoldRaccoon
@onready var mystery_forest_npcs: Node2D = $MysteryForest/NPCs


func _on_legendary_golden_raccoon_fight_player_enter(player : Player) -> void:
#	_legendary_golden_raccoon_fight.queue_free()
	_block_legendary_golden_raccoon_path()
	giant_gold_raccoon.target = player


func _block_legendary_golden_raccoon_path() -> void:
	var tree_positions := PackedVector2Array([
		Vector2i(-2, 201), Vector2i(-1, 201), Vector2i(0, 201),
		Vector2i(-2, 202), Vector2i(-1, 202), Vector2i(0, 202)
	])
	over_world_tilemap.add_forest_trees(tree_positions)
 

func _unblock_legendary_golden_raccoon_path() -> void:
	var tree_positions := PackedVector2Array([
		Vector2i(-2, 201), Vector2i(-1, 201), Vector2i(0, 201),
		Vector2i(-2, 202), Vector2i(-1, 202), Vector2i(0, 202)
	])
	over_world_tilemap.remove_trees(tree_positions)


func spawn_all_monks() -> void:
	# Spawn all 4 monks
	var monk_1 : NPC = preload("res://scenes/monk_1.tscn").instantiate()
	var monk_2 : NPC = preload("res://scenes/monk_2.tscn").instantiate()
	var monk_3 : NPC = preload("res://scenes/monk_3.tscn").instantiate()
	var monk_4 : NPC = preload("res://scenes/monk_4.tscn").instantiate()
	
	monk_1.global_position = Vector2( 88, 3192)
	monk_2.global_position = Vector2(128, 3200)
	monk_3.global_position = Vector2(168, 3192)
	monk_4.global_position = Vector2(128, 3160)
	
	mystery_forest_npcs.call_deferred("add_child", monk_1)
	mystery_forest_npcs.call_deferred("add_child", monk_2)
	mystery_forest_npcs.call_deferred("add_child", monk_3)
	mystery_forest_npcs.call_deferred("add_child", monk_4)


func _on_giant_gold_raccoon_hit(node : Node2D) -> void:
	print("OverWorld::_on_giant_gold_raccoon_hit: ", node.name)
	if not node is Player:
		return
	
	# fade screen to black
	
	# remove raccoon
	_legendary_golden_raccoon_fight.queue_free()
	giant_gold_raccoon.queue_free()
	
	# clear all paths
	MysteryForestAutoload.complete_monk_3_quest()
	_unblock_legendary_golden_raccoon_path()
	
	# Spawn all 4 monks
	spawn_all_monks()
	
	# move player
	node.global_position = Vector2(128, 3136)
	
	# start monk 4 dialgoue
