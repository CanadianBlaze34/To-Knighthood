class_name RoesMilk extends PickupableItem

func _init() -> void:
	if not Village1.spawn_roes_milk():
		queue_free()
