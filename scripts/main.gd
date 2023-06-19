class_name Main extends Node2D

@onready var player: Player = $Player
var active_scene : Node


func _ready() -> void:
	_load_scene()
	_load_player_position()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("title_menu"):
		_title_menu()
	elif event.is_action_pressed("save"):
		_save()


func _title_menu() -> void:
#	var title_menu : TitleMenu = load("res://scenes/title_menu.tscn").instantiate()
	var title_menu = load("res://scenes/title_menu.tscn").instantiate()
	queue_free()
	get_parent().call_deferred("add_child", title_menu)


func _save() -> void:
	var data : Dictionary = {}
	data.merge(_get_save_scene(), true)
	data.merge(_get_save_player_position(), true)
	SaveLoad.save(data)
	print("Saved player position and scene.")


func _load_scene() -> void:
	const scene : String = "scene"
	var data := SaveLoad.get_loaded([scene])
	
	if scene in data:
		var loaded_scene = load(data[scene]).instantiate()
		add_child(loaded_scene)
	else:
		print("No scene to load.")
		const player_room_path : String = "res://scenes/player_room.tscn"
		var player_room : PlayerRoom = load(player_room_path).instantiate()
		call_deferred("add_child", player_room)
		# save the room into the save
		SaveLoad.save(
			{
				scene : player_room_path
			}
		)


func _get_save_scene() -> Dictionary:
	const scene : String = "scene"
	var active_scene_path : String = active_scene.get_scene_file_path()
	if active_scene_path.is_empty():
		push_error("active scene path doesn't exist.")
		assert(false)
	# save the room into the save
	return {
		scene : active_scene_path
	}


func _load_player_position() -> void:
	const player_position_x : String = "player_position_x"
	const player_position_y : String = "player_position_y"
	var data := SaveLoad.get_loaded([player_position_x, player_position_y])
	
	if player_position_x in data:
		var player_pos_x : float = float(data[player_position_x])
		var player_pos_y : float = float(data[player_position_y])
		player.global_position.x = player_pos_x
		player.global_position.y = player_pos_y
	else:
		print("No player position to load.")
		const player_position := Vector2(87.0, 50.0)
		player.global_position = player_position
		# save the position into the save
		SaveLoad.save(
			{
				player_position_x : str(player_position.x),
				player_position_y : str(player_position.y)
			}
		)


func _get_save_player_position() -> Dictionary:
	const player_position_x : String = "player_position_x"
	const player_position_y : String = "player_position_y"
	
	# save the position into the save
	return {
		player_position_x : str(player.global_position.x),
		player_position_y : str(player.global_position.y)
	}


func _on_child_entered_tree(node: Node) -> void:
	active_scene = node






