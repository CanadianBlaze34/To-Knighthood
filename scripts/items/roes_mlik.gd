class_name RoesMilk extends PickupableItem

func _init() -> void:
	if Village1.spawn_roes_milk():
		print("spawn roes milk")
	else:
		queue_free()
