class_name PickupableItemArea extends Area2D

var items_to_pickup : Array[PickupableItem]

signal item_pickup(pickupable_item : PickupableItem)

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pickup_item"):
		if items_to_pickup.size(): 
			_pickup_item()
		else:
			print("No item to pickup.")


func _pickup_item() -> void:
	# grab the last item to be reconized. Like a stack
	var pickupable_item: PickupableItem = items_to_pickup.back()
	print("picked up %s." % [pickupable_item.item.name])
	Village1.has_item.emit(pickupable_item.item.id)
	item_pickup.emit(pickupable_item)
	pickupable_item.pickedup()
	pickupable_item.queue_free()
	# doesn't need to be removed beacuse '_on_pickupable_item_area_exited' will
	# remove the PickupableItem while it is being freed


func _on_area_entered(area: Area2D) -> void:
	var pickupable_item = area.get_parent() as PickupableItem
	var can_pickup : bool = not items_to_pickup.has(pickupable_item)
	if can_pickup:
		print("can  pick up %s." % [pickupable_item.item.name])
		items_to_pickup.append(pickupable_item)


func _on_area_exited(area: Area2D) -> void:
	var pickupable_item = area.get_parent() as PickupableItem
	var cant_pickup : bool = items_to_pickup.has(pickupable_item)
	if cant_pickup:
		print("cant pick up %s." % [pickupable_item.item.name])
		items_to_pickup.erase(pickupable_item)
