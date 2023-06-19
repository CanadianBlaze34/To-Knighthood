class_name InventorySlot extends TextureRect

@onready var item_container: Control = $ItemContainer as Control
@onready var item_slot: ItemSlot = $ItemContainer/ItemSlot

var item : Item : set = set_item


func set_item(new_item : Item) -> void:
	if not new_item:
		item = null
		item_slot.texture = null
	
	elif not item:
		item = new_item
		item_slot.texture = item.texture


func pick_item() -> void:
	item_slot.pick_item()
	set_item(null)


func put_item(new_item : Item) -> void:
	set_item(new_item)
	item_slot.put_item()

