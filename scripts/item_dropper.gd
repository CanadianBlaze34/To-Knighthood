class_name ItemDropper extends Node

@export var item : ItemData
@export var quantity : int = 1

func drop_item(position : Vector2) -> void:
	print("ItemDropper::drop_item: %s" % item.name)
	ItemSpawnerAutoload.spawn_item(position, item, quantity)
