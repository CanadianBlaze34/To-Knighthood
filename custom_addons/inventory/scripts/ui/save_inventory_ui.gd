# https://www.youtube.com/watch?v=dMYv6InQgno&list=PLcZp9zrMgnmOOQXevC-2CfH67QP3mB4wv&ab_channel=Calame321
class_name SaveInventoryUI extends InventoryUI


func _ready() -> void:
	super._ready()
	SaveLoad.variables_loaded_from_file.connect(_load_inventory_from_file)


func _load_inventory_from_file() -> void:
	# key used to fetch and save the inventory information
	const player_inventory : String = "player_inventory"
	const size_ : String = "size"
	const items : String = "items"
	
	var file_inventory_data : Dictionary = SaveLoad.get_loaded([player_inventory])
	
	# save an empty inventory with the current size
	if file_inventory_data.is_empty():
		save_inventory()
		
	else:
		# remove the outer dictionary, it's meant to find the inner dictinoary in the save file
		file_inventory_data = file_inventory_data[player_inventory]
		
		print("loading inventory: ", file_inventory_data)
		# resize slots
		var loaded_size : int = file_inventory_data[size_]
		if loaded_size != inventory_size:
			if loaded_size < inventory_size:
				print("removing %d more slots." % [inventory_size - loaded_size])
				remove_slots(inventory_size - loaded_size)
			else:
				print("making %d more slots." [loaded_size - inventory_size])
				add_slots(loaded_size - inventory_size)
		else:
				print("default inventory has wanted slots(%d)." % [inventory_size])
		
		# add the items
		const item_id_index : int = 0
		const item_quantity_index : int = 1
		
		for slot_index in file_inventory_data[items].size():
			var inventory_slot : Array = file_inventory_data[items][slot_index]
			# not empty slot
			if inventory_slot[item_id_index] >= 0:
				var item_id : int = inventory_slot[item_id_index]
				var quantity : int = inventory_slot[item_quantity_index]
				data.add_item(item_id, quantity, slot_index)
				slots[slot_index].add_item(data.slot_item(slot_index))
				print("Slot %d has %d '%s' item(s)." % [slot_index, data.slot_quantity(slot_index), data.slot_item(slot_index).name])
			else:
				print("Slot %d has no item." % [slot_index])
				slots[slot_index].remove_item()
				data.remove_item(slot_index)
			


func save_inventory() -> void:
	# key used to fetch and save the inventory information
	const player_inventory : String = "player_inventory"
	const size_ : String = "size"
	const items : String = "items"
	
	var items_info : Array[Array] = [] # Array[item_slot : Array[item_id : int, quantity : int]]
	items_info.resize(inventory_size)
	for i in inventory_size:
		var item_id : int = -1
		var quantity : int = 0
		
		if data.slot_has_item(i):
			item_id = data.slot_item_id(i)
			quantity = data.slot_quantity(i)
		
		items_info[i] = [item_id, quantity]
	
	var inventory_to_save : Dictionary = {
		player_inventory : {
			size_ : inventory_size,
			items : items_info
		}
	}
	print("saving inventory: ", inventory_to_save)
	SaveLoad.save(inventory_to_save, true)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("save"):
		save_inventory()

