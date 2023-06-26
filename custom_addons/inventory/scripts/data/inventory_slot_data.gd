class_name InventorySlotData extends Object

var item_id : int = -1
var quantity : int = 0

func get_item() -> ItemData:
	return PreloadItemsAutoload.get_item(item_id)


func add_item(id : int, quantity_ : int) -> void:
	item_id = id
	quantity = quantity_


func remove_item() -> void:
	item_id = -1
	quantity = 0


func has_item() -> bool:
	return item_id >= 0


func remove_quantity(quantity_ : int) -> void:
	quantity -= quantity_
