class_name InventorySlotUI extends TextureRect

@onready var item_container: Control = $ItemContainer as Control
@onready var item_slot : ItemUI = $ItemContainer/ItemUI


func add_item(item : ItemData) -> void:
	item_slot.texture = item.texture


func remove_item() -> void:
	item_slot.texture = null


func pick_item() -> void:
	item_slot.pick_item()
	remove_item()


func put_item(new_slot : InventorySlotData) -> void:
	add_item(new_slot.item)
	item_slot.put_item()


func has_item() -> bool:
	return item_slot.texture != null
