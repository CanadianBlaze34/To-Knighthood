# https://www.youtube.com/watch?v=dMYv6InQgno&list=PLcZp9zrMgnmOOQXevC-2CfH67QP3mB4wv&ab_channel=Calame321
class_name InventoryUI extends NinePatchRect

@export var inventory_size : int = 0 #: set = set_inventory_size
@export var columns : int = 4 #: set = set_inventory_size

@onready var slot_container: GridContainer = $SlotContainer
@onready var inventory_slot_res := preload("res://custom_addons/inventory/scenes/inventory_slot.tscn")
@onready var drop_box: DropBoxUI = $DropBox

signal drop_item(slot_data : InventorySlotData)
signal equip_item(item: EquipableItem, slot_index : int)


var slots : Array[InventorySlotUI] = []
var data : InventoryData

func _ready() -> void:
	slot_container.columns = columns
	drop_box.hide()
	hide()
	ready_inventory(inventory_size)
	hidden.connect(_on_hidden)
	mouse_exited.connect(_on_mouse_exited)


func _on_inventory_slot_gui_input(event : InputEvent, slot_index : int) -> void:
	if not event is InputEventMouseButton:
		return 
	
	# left mouse button has been pressed
	if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if data.slot_has_item(slot_index):
			_create_item_drop_box(slot_index)
		else:
			drop_box.hide()


func _create_item_drop_box(slot_index : int) -> void:
	
	var inventory_slot: InventorySlotUI = slots[slot_index]
	var inventory_slot_data: InventorySlotData = data.inventory[slot_index]
	
	const offset := -Vector2.ONE * 2
	var new_position := inventory_slot.global_position + inventory_slot.size + offset
	
	if new_position != drop_box.global_position or not drop_box.visible:
		drop_box.global_position = new_position
		
		var names_and_functions : Dictionary =\
			_generate_names_and_functions(inventory_slot_data, slot_index)
		
		drop_box.make_buttons(names_and_functions)
		
		# make all the actions into buttons
		# connect all the buttons to functions or signals
		# connect the buttons to a signal to hide the drop_box and 
		# remove all the buttons on press
		
		drop_box.show()
		
	else:
		drop_box.visible = not drop_box.visible


func _generate_names_and_functions(slot_data : InventorySlotData, slot_index : int) -> Dictionary:
	var names_and_functions : Dictionary = {}
	
	var slot_data_item : ItemData = slot_data.get_item()
	
	if slot_data_item is EquipableItem:
		if slot_data_item.equiped:
			names_and_functions["Unequip"] = func():
				equip_item.emit(slot_data_item as EquipableItem, slot_index)
				drop_box.hide()
		else:
			names_and_functions["Equip"] = func():
				equip_item.emit(slot_data_item as EquipableItem, slot_index)
				drop_box.hide()
	
	
	names_and_functions["Drop"] = func():
		drop_item.emit(slot_data)
		empty_slot(slot_data_item)
		drop_box.global_position = -Vector2.ONE
		drop_box.hide()
	
	
	return names_and_functions


func ready_inventory(new_size : int) -> void:
	
	inventory_size = new_size
	
	# resize the inventory dat
	data = InventoryData.create(inventory_size)
	data.create_slots()
	# there is a built in function for this
	# don't wanna keep looping over the same loop
	data.inventory = []
	data.inventory.resize(data.size)
	
	
	# resize the inventory UI
	const min_size_y : int = 36
	const additional_row_height : int = 24
	@warning_ignore("integer_division")
	var rows : int = inventory_size / (columns + 1)
	
	@warning_ignore("integer_division")
	custom_minimum_size.y = min_size_y + rows * additional_row_height
	
	for slot_index in inventory_size:
		# spawn the slot data
		data.inventory[slot_index] = InventorySlotData.new()
		# spawn the UI slots
		var new_slot : InventorySlotUI = inventory_slot_res.instantiate()
		slots.append(new_slot)
		new_slot.gui_input.connect(_on_inventory_slot_gui_input.bind(slot_index))
		slot_container.add_child(new_slot)

func has_item(item : ItemData) -> bool:
	for index in inventory_size:
		if data.slot_has_item(index) and data.slot_item_id(index) == item.id:
			return true
	return false


func add_slots(quantity : int) -> void:
	data.inventory.resize(inventory_size + quantity)
	for i in quantity:
		var slot_index : int = i + inventory_size
		# spawn the slot data
		data.inventory[slot_index] = InventorySlotData.new()
		# spawn the UI slots
		var new_slot : InventorySlotUI = inventory_slot_res.instantiate()
		slots.append(new_slot)
		new_slot.gui_input.connect(_on_inventory_slot_gui_input.bind(slot_index))
		slot_container.add_child(new_slot)
	inventory_size += quantity

func remove_slots(quantity : int) -> void:
	for i in quantity:
		var slot_index : int = inventory_size - 1 - i
		slot_container.remove_child(slots[slot_index])
		data.inventory[slot_index] = null
	
	data.inventory.resize(inventory_size - quantity)
	inventory_size -= quantity

func empty_slot_by_index(index : int) -> void:
	data.remove_item(index)
	slots[index].remove_item()

func add_item_to_slot_by_index(item : ItemData, quantity : int, index : int) -> void:
	data.add_item(item.id, quantity, index)
	slots[index].add_item(item)


func add_item(item : ItemData, quantity : int) -> void:
	for slot_index in inventory_size:
		if not data.slot_has_item(slot_index):
			# add item to slot
			add_item_to_slot_by_index(item, quantity, slot_index)
			return


func empty_slot(item : ItemData) -> void:
#	for slot in slots:
#		if slot.item:
#			# remove item in slot
#			if slot.item.name == item.name:
#				slot.set_item(null)
#				return
	empty_slot_by_id(item.id)


func empty_slot_by_name(item_name : String) -> void:
	for slot_index in inventory_size:
		if data.slot_has_item(slot_index):
			# remove item in slot
			if data.slot_item(slot_index).name == item_name:
				empty_slot_by_index(slot_index)
				return


func empty_slot_by_id(item_id : int) -> void:
	for slot_index in inventory_size:
		if data.slot_has_item(slot_index):
			# remove item in slot
			if data.slot_item_id(slot_index) == item_id:
				empty_slot_by_index(slot_index)
				return


func remove_item_quantity(item : ItemData, quantity : int) -> void:
	
	for index in data.size:
		
		var has_item_ : bool = data.slot_has_item(index)
		if not has_item_: 
			continue
		
		var item_in_slot : bool = data.slot_item_id(index) == item.id
		if not item_in_slot:
			continue
		
		
		var quantity_in_slot : int = data.slot_quantity(index)
		if quantity_in_slot != quantity:
			if quantity_in_slot > quantity:
				data.remove_quantity(quantity, index)
				break
			else:
				quantity -= quantity_in_slot
				empty_slot_by_index(index)
		else:
			empty_slot_by_index(index)
			break


func item_amount(item : ItemData) -> int:
	return data.item_amount(item)



func _on_mouse_exited() -> void:
	# this function will also be triggered when entering a child node
	
	# mouse has left the control area
	if not get_rect().has_point(get_global_mouse_position()):
		drop_box.hide()


func _on_hidden() -> void:
	drop_box.hide()
