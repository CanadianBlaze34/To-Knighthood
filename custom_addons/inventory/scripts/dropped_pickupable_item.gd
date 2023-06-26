class_name DroppedPickupableItem extends PickupableItem


func _ready() -> void:
	
	var area2d : Area2D = _make_area2d_on_pickup_layer()
	
	# CollisionsShape2D with CircleShape2D
	var collisionshape2d := CollisionShape2D.new()
	collisionshape2d.shape = CircleShape2D.new()
	collisionshape2d.name = "CollisionShape2D"
	
	# add Nodes to tree
	area2d.add_child(collisionshape2d)
	add_child(area2d)
	
	_ready_variabless()
	print("DroppedPickupableItem::_ready: item name '%s'" % [name])
	PickupableItemTrackerAutoload.dropped_PickupableItem_spawned.emit(self)


func pickedup() -> void:
	PickupableItemTrackerAutoload.dropped_PickupableItem_removed.emit(self)


func _make_area2d_on_pickup_layer() -> Area2D:
	# Area2d on Collisions layer 6 'Pickup Item'
	const pickup_item_layer: int = 6 # not the bit
	
	var area2d : Area2D = Area2D.new()
	# set 'Pickup Item' layer
	area2d.set_collision_layer_value(pickup_item_layer, true)
	
	# unset first layer
	area2d.set_collision_layer_value(1, false)
	area2d.set_collision_mask_value(1, false)
	
	area2d.name = "Area2D"
	
	return area2d


static func generate_item(item_id : int, quantity_ : int, global_position_ : Vector2) -> DroppedPickupableItem:
	var pickupable : DroppedPickupableItem = DroppedPickupableItem.new()
	pickupable.position = global_position_
	pickupable.item = PreloadItemsAutoload.get_item(item_id)
	pickupable.quantity = quantity_
	return pickupable
