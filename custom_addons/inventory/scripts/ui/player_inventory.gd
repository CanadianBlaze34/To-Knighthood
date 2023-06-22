class_name PlayerInventory extends SaveInventoryUI

@export var player : Player

func _generate_names_and_functions(slot_data : InventorySlotData) -> Dictionary:
	var names_and_functions : Dictionary = {}
	
	
	if slot_data.item is EquipableItem:
		# player has the item already equiped
		if player.weapon and player.weapon.texture == slot_data.item.texture:
			names_and_functions["Unequip"] = func():
				equip_item.emit(slot_data.item as EquipableItem)
				drop_box.hide()
		else:
			names_and_functions["Equip"] = func():
				equip_item.emit(slot_data.item as EquipableItem)
				drop_box.hide()
	
	
	names_and_functions["Drop"] = func():
		drop_item.emit(slot_data)
		empty_slot(slot_data.item)
		drop_box.global_position = -Vector2.ONE
		drop_box.hide()
	
	
	return names_and_functions
