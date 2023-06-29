class_name PlayerInventory extends SaveInventoryUI

@export var player : Player

func _generate_names_and_functions(slot_data : InventorySlotData, slot_index : int) -> Dictionary:
	var names_and_functions : Dictionary = {}
	
	var slot_data_item : ItemData = slot_data.get_item()
	
	if slot_data_item is EquipableItem:
		# player has the item already equiped
		if player.weapon and player.weapon.texture == slot_data_item.texture:
			names_and_functions["Unequip"] = func():
				equip_item.emit(slot_data_item as EquipableItem, slot_index)
				drop_box.hide()
		else:
			names_and_functions["Equip"] = func():
				equip_item.emit(slot_data_item as EquipableItem, slot_index)
				drop_box.hide()
	
	
	names_and_functions["Drop"] = func():
		drop_item.emit(slot_data)
		empty_slot(slot_data_item)
		drop_box.global_position = -Vector2.ONE
		drop_box.hide()
	
	
	return names_and_functions
