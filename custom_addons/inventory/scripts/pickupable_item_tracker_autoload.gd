extends Node # Autoload

# loads all the PickupableItem nodes from the save file
#  PickupableItems will signal when they're ready
# this tracker will check the save file for the ready PickupableItem
# if it doesn't exist in the save file it will be set saved as 'alive'
# if it does and it's saved as 'alive' it will not be destroy
# if it does and it's saved as 'dead' it will be destroy

# on a loaded save 'dead' dropped_items should be removed from the save


# on startup, if the item isn't in the save, add its position and item to the 



# should only save position of dropped items and
# pickedup status of naturally spawned items should only save their death state 


#{
#	Scene { # when the scene has nothing to destroy or spawn it should be removed
#		dropped_item : 'dead' should be deleted from the save
#		
#		
#	}
#	Scene2 {
#		editor_placed_item : position # 'destroy'
#		
#		
#	}
#	Scene3 {
#		dropped_item { # should be spawned when scene active scene loads
#			item_name : [[position1, quantity],  [position2, quantity]]
#			item_name2 : [[position1, quantity]]
#		}
#		editor_item{ # should be queue_free() when spawned
#			item_name : [(position1),  position2]
#			item_name2 : [position1]
#		}
#	}
#	
#	
#	
#	
#}
const dropped_item_key : String = "dropped item" 
const editor_item_key : String = "editor item"
const saved_items_key : String = "saved_items"
const position_index: int = 0
const quantity_index: int = 1

var _saved_items : Dictionary = {}


var active_scene : Node
var active_scene_path : String

#keep this list and assign the items tree_exiting to remove it from the list
# saving will overwrite the list with no mention of the object if the item is removed
# when this is called it means an item has been dropped and it's alive state should be kept
# remove form the _save_items list if it's in it
signal dropped_PickupableItem_removed(pickupable_item) # : DroppedPickupableItem
# put into the saved_items list
signal dropped_PickupableItem_spawned(pickupable_item) # : DroppedPickupableItem
# keep this list and assign the items tree_exiting to change its state

signal editor_PickupableItem_removed(pickupable_item) # : PickupableItem
# check if this item is saved, if it is, it will be destroyed
signal editor_PickupableItem_spawned(pickupable_item) # : PickupableItem


func _ready() -> void:
#	return
	_connect_signals()


func _on_variables_loaded_from_file() -> void:
	var loaded_items : Dictionary = SaveLoad.get_loaded([saved_items_key])
	if not loaded_items.is_empty():
		# erase the key used to represent the save in the saved file 
		_saved_items = loaded_items[saved_items_key] 
		print("PickupableItemTrackerAutoload: loaded. ", _saved_items)
	else:
		print("PickupableItemTrackerAutoload: Nothing to load.")
		_saved_items = {}


func _input(event: InputEvent) -> void:
#	return
	if event.is_action_pressed("save"):
		var saved_items : Dictionary = { saved_items_key : _saved_items}
		SaveLoad.save(saved_items, true)
		print("PickupableItemTrackerAutoload: Saving. ", _saved_items)


func set_scene(new_scene : Node) -> void:
	active_scene = new_scene
	active_scene_path = active_scene.get_scene_file_path()


func on_scene_ready(new_scene : Node) -> void:
	# try to load the scene that has been changed to
	# keep all items tracked with all their scenes loaded in a local dictionary 
	# if there are items in the new scene, load the items at their location
	# if not, return and do nothing
	# do not save
#	set_scene(new_scene)
	print("PickupableItemTrackerAutoload: active_scene = '%s'." % [active_scene_path])
	_spawn_dropped_items()


func _spawn_dropped_items() -> void:
	# the active scene has dropped items to spawn
	if not _has_item_type(true):
		print("PickupableItemTrackerAutoload: No 'dropped_items' to spawn in '%s'." % [active_scene_path])
		return
	
	for item_id in _saved_items[active_scene_path][dropped_item_key].duplicate():
		
		var item_slots : Array = _scene_items_of(int(item_id), true)
		
		for item_slot in item_slots:
			var item_position : Vector2 = (
				item_slot[position_index] if item_slot[position_index] is Vector2
				else str_to_var("Vector2" + item_slot[position_index])
			)
			var item_quantity : int = item_slot[quantity_index] as int
			var pickupable_item := DroppedPickupableItem.generate_item(int(item_id), item_quantity, item_position)
			
			active_scene.add_child(pickupable_item)
			print("PickupableItemTrackerAutoload: Spawning '%d' '%s'(s) at '%v' to '%s'." % [item_quantity, pickupable_item.item.name, item_position, active_scene.name])


func _connect_signals() -> void:
	SaveLoad.variables_loaded_from_file.connect(_on_variables_loaded_from_file)
	
	dropped_PickupableItem_removed.connect(_on_dropped_PickupableItem_removed)
	dropped_PickupableItem_spawned.connect(_on_dropped_PickupableItem_spawned)
	
	editor_PickupableItem_removed.connect(_on_editor_PickupableItem_removed)
	editor_PickupableItem_spawned.connect(_on_editor_PickupableItem_spawned)


func _item_type_key(is_dropped_item : bool) -> String:
	return dropped_item_key if is_dropped_item else editor_item_key


func _scene_items_of(pickable_item_id : int, is_dropped_item : bool)-> Array:
	# the items with the name in the active scene
	return _saved_items[active_scene_path][_item_type_key(is_dropped_item)][str(pickable_item_id)]


func _has_item_type(is_dropped_item : bool) -> bool:
	return active_scene_path in _saved_items and _item_type_key(is_dropped_item) in _saved_items[active_scene_path]


func _make_saved_item(pickable_item_id : int, is_dropped_item : bool) -> void:
	
	var item_type_key : String = _item_type_key(is_dropped_item)
	
	if not active_scene_path in _saved_items:
		print("PickupableItemTrackerAutoload: making '%s' in _saved_items." % [active_scene_path])
		_saved_items[active_scene_path] = {}
	
	if not _saved_items[active_scene_path].has(item_type_key):
		print("PickupableItemTrackerAutoload: making '%s' in _saved_items[%s]." % [item_type_key, active_scene_path])
		_saved_items[active_scene_path][item_type_key] = {}
	
	if not _saved_items[active_scene_path][item_type_key].has(str(pickable_item_id)):
		print("PickupableItemTrackerAutoload: making '%d'('%s') in _saved_items[%s][%s]." % [pickable_item_id, PreloadItemsAutoload.get_item(pickable_item_id).name, active_scene_path, item_type_key])
		_saved_items[active_scene_path][item_type_key][str(pickable_item_id)] = []


func _clear_saved_dropped_items(pickable_item_id : int) -> void:
	
	if _saved_items[active_scene_path][dropped_item_key][str(pickable_item_id)].is_empty():
		print("PickupableItemTrackerAutoload: removing '%d'('%s') from _saved_items[%s][%s]. Is empty" % [pickable_item_id, PreloadItemsAutoload.get_item(pickable_item_id).name, active_scene_path, dropped_item_key])
		_saved_items[active_scene_path][dropped_item_key].erase(pickable_item_id)
	
	if _saved_items[active_scene_path][dropped_item_key].is_empty():
		print("PickupableItemTrackerAutoload: removing '%s' from _saved_items[%s]. Is empty" % [dropped_item_key, active_scene_path])
		_saved_items[active_scene_path].erase(dropped_item_key)
	
	if _saved_items[active_scene_path].is_empty():
		print("PickupableItemTrackerAutoload: removing '%s' from _saved_items. Is empty" % [active_scene_path])
		_saved_items.erase(active_scene_path)


func _index_at(pickupable_item, is_dropped_item : bool) -> int:
	var index = -1
	
	# _saved_items at the item id is empty
	if (not _has_item_type(is_dropped_item) or 
			not _saved_items[active_scene_path][_item_type_key(is_dropped_item)].has(str(pickupable_item.item.id))):
#		print("PickupableItemTrackerAutoload: returning early on '%s', id: '%d'." % [pickupable_item.name, pickupable_item.item.id])
#		print(not _has_item_type(is_dropped_item))
#		print(not _saved_items[active_scene_path][_item_type_key(is_dropped_item)].has(str(pickupable_item.item.id)))
#		print(_saved_items)
		return index
	
	var item_slots : Array = _scene_items_of(pickupable_item.item.id, is_dropped_item)
	var pickable_item_slot : Array = [pickupable_item.position, pickupable_item.quantity]
	
	for item_slot_index in item_slots.size():
		var item_slot : Array = item_slots[item_slot_index]
		
		if (str(item_slot[position_index]) == str(pickable_item_slot[position_index]) and 
				int(item_slot[quantity_index]) == pickable_item_slot[quantity_index]):
			index = item_slot_index
			break
	
	return index


func _append(pickupable_item, is_dropped_item : bool) -> void:
	var pickable_item_slot : Array = [pickupable_item.global_position, pickupable_item.quantity]
	_scene_items_of(pickupable_item.item.id, is_dropped_item).append(pickable_item_slot)
	print("PickupableItemTrackerAutoload: Appending '%d' '%s'(s) at '%v' to _saved_items[%s][%s]."
		% [pickupable_item.quantity, pickupable_item.name, pickupable_item.global_position, active_scene_path, _item_type_key(is_dropped_item)])


func _on_dropped_PickupableItem_removed(pickupable_item) -> void:
	print("PickupableItemTrackerAutoload: Removing '%d' '%s'(s) at '%v' from _saved_items[%s][%s]."
		% [pickupable_item.quantity, pickupable_item.name, pickupable_item.global_position, active_scene_path, dropped_item_key])
	_scene_items_of(pickupable_item.item.id, true).remove_at(_index_at(pickupable_item, true))
	_clear_saved_dropped_items(pickupable_item.item.id)


func _on_dropped_PickupableItem_spawned(pickupable_item) -> void:
	var index : int = _index_at(pickupable_item, true)
	# pickupable_item not found in _saved_items
	if index == -1:
		_make_saved_item(pickupable_item.item.id, true)
		_append(pickupable_item, true)


func _on_editor_PickupableItem_removed(pickupable_item) -> void:
	# will be called after the queue_free in _on_editor_PickupableItem_spawned
#	if active_scene != pickupable_item.owner:
#		# prevents removing items when changing scenes
#		return

	_make_saved_item(pickupable_item.item.id, false)
	var index : int = _index_at(pickupable_item, false)
	# pickupable_item not found in _saved_items
	if index == -1:
		_append(pickupable_item, false)


func _on_editor_PickupableItem_spawned(pickupable_item) -> void:
	# if more than 1 of the same item is at the same location in the same scene, pickedup and saved
	# all of those items will despawn
	
	# will change early but won't effect anything drastic
#	if active_scene != pickupable_item.owner:
#		active_scene = pickupable_item.owner
#		active_scene_path = active_scene.get_scene_file_path()
#		print("PickupableItemTrackerAutoload: active_scene = '%s'." % [active_scene_path])
	
	var index : int = _index_at(pickupable_item, false)
	# pickupable_item found in _saved_items
	if index != -1:
		pickupable_item.queue_free()
		print("PickupableItemTrackerAutoload: removing editor '%s'." % [pickupable_item.name])
	else:
		print("PickupableItemTrackerAutoload: not removing editor '%s'." % [pickupable_item.name])













