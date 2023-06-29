class_name InventoryData extends Object


var size : int
var inventory : Array[InventorySlotData]

static func create(size_ : int) -> InventoryData:
	var inventory_data := InventoryData.new()
	inventory_data.size = size_
	return inventory_data


func create_slots() -> void:
	inventory = []
	inventory.resize(size)
	for i in size:
		inventory[i] = InventorySlotData.new()


func add_item_to_open_slot(item_id : int, quantity : int) -> void:
	for i in size:
		if not inventory[i].has_item():
			add_item(item_id,  quantity, i)
			break


func add_item(item_id : int, quantity : int, index : int) -> void:
	inventory[index].add_item(item_id, quantity)


func remove_item(index : int) -> void:
	inventory[index].remove_item()


func remove_quantity(quantity : int, index : int) -> void:
	inventory[index].remove_quantity(quantity)


func remove_item_quantity(item : ItemData, quantity : int) -> void:
	
	for index in size:
		
		var has_item : bool = slot_has_item(index)
		if not has_item: 
			continue
		
		var item_in_slot : bool = slot_item_id(index) == item.id
		if not item_in_slot:
			continue
		
		
		var quantity_in_slot : int = slot_quantity(index)
		if quantity_in_slot != quantity:
			if quantity_in_slot > quantity:
				remove_quantity(quantity, index)
				break
			else:
				quantity -= quantity_in_slot
				remove_item(index)
		else:
			remove_item(index)
			break


func item_amount(item : ItemData) -> int:
	
	var item_amount_ : int = 0
	
	for index in size:
		
		var has_item : bool = slot_has_item(index)
		if not has_item: 
			continue
		
		var item_in_slot : bool = slot_item_id(index) == item.id
		if not item_in_slot:
			continue
		
		item_amount_ += slot_quantity(index)
		break
	
	return item_amount_


func slot_has_item(index : int) -> bool:
	return inventory[index].has_item()


func slot_quantity(index : int) -> int:
	return inventory[index].quantity


func slot_item(index : int) -> ItemData:
	return inventory[index].get_item()

func slot_item_id(index : int) -> int:
	return inventory[index].item_id
