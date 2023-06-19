# https://www.youtube.com/watch?v=dMYv6InQgno&list=PLcZp9zrMgnmOOQXevC-2CfH67QP3mB4wv&ab_channel=Calame321
class_name Inventory extends NinePatchRect

@export var inventory_size : int = 0 #: set = set_inventory_size

@onready var slot_container: GridContainer = $SlotContainer
@onready var inventory_slot_res := preload("res://scenes/inventory/inventory_slot.tscn")
@onready var drop_box: DropBox = $DropBox

signal drop_item(item: Item)
signal equip_item(item: EquipableItem)


var slots : Array[InventorySlot] = []


func _ready() -> void:
	drop_box.hide()
	hide()
	
	set_inventory_size(inventory_size)
	for slot in slots:
		slot_container.add_child(slot)
#		slot.gui_input.connect(func (event : InputEvent): _on_gui_input_inventory_slot(event, slot))
		slot.gui_input.connect(_on_gui_input_inventory_slot.bind(slot))


func _on_gui_input_inventory_slot(event : InputEvent, inventory_slot: InventorySlot) -> void:
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton 
		# left mouse button has been pressed
		if mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT:
			if inventory_slot.item:
				_make_item_drop_box(inventory_slot)
			else:
				drop_box.hide()


func _make_item_drop_box(inventory_slot: InventorySlot) -> void:
	
	const offset := -Vector2.ONE * 2
	var new_position := inventory_slot.global_position + inventory_slot.size + offset
	
	if new_position != drop_box.global_position or not drop_box.visible:
		drop_box.global_position = new_position
		
		var names_and_functions : Dictionary =\
			_generate_names_and_functions(inventory_slot.item)
		
		drop_box.make_buttons(names_and_functions)
		
		# make all the actions into buttons
		# connect all the buttons to functions or signals
		# connect the buttons to a signal to hide the drop_box and 
		# remove all the buttons on press
		
		drop_box.show()
		
	else:
		drop_box.visible = not drop_box.visible


func _generate_names_and_functions(item : Item) -> Dictionary:
	var names_and_functions : Dictionary = {}
	
	
	if item is EquipableItem:
		if item.equiped:
			names_and_functions["Unequip"] = func():
				equip_item.emit(item as EquipableItem)
				drop_box.hide()
		else:
			names_and_functions["Equip"] = func():
				equip_item.emit(item as EquipableItem)
				drop_box.hide()
	
	
	names_and_functions["Drop"] = func():
		drop_item.emit(item)
		remove_item(item)
		drop_box.global_position = -Vector2.ONE
		drop_box.hide()
	
	
	return names_and_functions


func set_inventory_size(new_size : int) -> void:
	inventory_size = new_size
	const min_size_y : int = 36
	const additional_row_height : int = 24
	var columns : int = slot_container.columns
	@warning_ignore("integer_division")
	var rows : int = new_size / (columns + 1)
	
	@warning_ignore("integer_division")
	custom_minimum_size.y = min_size_y + rows * additional_row_height
	
	# make x number of slots
	for slot in inventory_size:
		var new_slot := inventory_slot_res.instantiate()
		slots.append(new_slot)


func add_item(item : Item) -> void:
	for slot in slots:
		if not slot.item:
			# add item to slot
			slot.set_item(item)
			return


func remove_item(item : Item) -> void:
	for slot in slots:
		if slot.item:
			# remove item in slot
			if slot.item.name == item.name:
				slot.set_item(null)
				return


func remove_item_by_name(item_name : String) -> void:
	for slot in slots:
		if slot.item:
			# remove item in slot
			if slot.item.name == item_name:
				slot.set_item(null)
				return


func _on_mouse_exited() -> void:
	# mouse has left the control area
	# this function will also be triggered when entering a child node
	if not get_rect().has_point(get_global_mouse_position()):
		drop_box.hide()


func _on_hidden() -> void:
	drop_box.hide()
