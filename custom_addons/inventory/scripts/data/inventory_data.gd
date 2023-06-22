class_name InventoryData extends Object


var size : int
var inventory : Array[InventorySlotData]

static func create(size : int) -> InventoryData:
	var inventory_data := InventoryData.new()
	inventory_data.size = size
	return inventory_data


func create_slots() -> void:
	inventory = []
	inventory.resize(size)
	for i in size:
		inventory[i] = InventorySlotData.new()


func add_item_to_open_slot(item : ItemData, quantity : int) -> void:
	for i in size:
		if not inventory[i].has_item():
			add_item(item,  quantity, i)
			break


func add_item(item : ItemData, quantity : int, index : int) -> void:
	inventory[index].add_item(item, quantity)


func remove_item(index : int) -> void:
	inventory[index].remove_item()


func remove_quantity(quantity : int, index : int) -> void:
	inventory[index].remove_quantity(quantity)


func slot_has_item(index : int) -> bool:
	return inventory[index].has_item()


func slot_quantity(index : int) -> int:
	return inventory[index].quantity
