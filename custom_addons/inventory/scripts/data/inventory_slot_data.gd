class_name InventorySlotData extends Object

var item : ItemData
var quantity : int = 0


func add_item(item_ : ItemData, quantity_ : int) -> void:
	item = item_
	quantity = quantity_


func remove_item() -> void:
	item = null
	quantity = 0


func has_item() -> bool:
	return item != null


func remove_quantity(quantity_ : int) -> void:
	quantity -= quantity_
