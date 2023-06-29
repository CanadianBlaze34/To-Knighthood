class_name ItemSpawnerAutoload_ extends Node2D # Autoload

signal save_exited

func _ready() -> void:
	print("ItemSpawnerAutoload_::_ready")
	save_exited.connect(_on_save_exited)


func _on_save_exited()-> void:
	print("ItemSpawnerAutoload_::func _on_save_exited()-> void:")
	# remove all children
	for child in get_children():
		child.queue_free()


func spawn_item(position_ : Vector2, item : ItemData, quantity : int) -> void:
	print("ItemSpawnerAutoload_::spawn_item: %s" % item.name)
	var pickupable_item_prefab := preload("res://custom_addons/inventory/scenes/pickupable_item.tscn")
	var pickupable_item : PickupableItem = pickupable_item_prefab.instantiate()
	pickupable_item.item = item
	pickupable_item.quantity = quantity
	pickupable_item.global_position = position_
	call_deferred("add_child", pickupable_item)
