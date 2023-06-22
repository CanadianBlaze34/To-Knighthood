class_name Player extends CharacterBody2D

@export var weapon : Weapon

@onready var equipable_weapon: Sprite2D = $EquipableWeapon
@onready var attack_box: Area2D = $AttackBox
@onready var attack_box_collision_box: CollisionShape2D = $AttackBox/CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var dialogue_area: PlayerDialogueArea = $DialogicArea
@onready var movement: Movement = $movement
@onready var inventory: PlayerInventory = $UI/PlayerInventory
@onready var pickupable_item_area: PickupableItemArea = $PickupableItemArea

@onready var _pickupable_item_res := preload("res://custom_addons/inventory/scenes/pickupable_item.tscn")

var attacking : bool = true
var save_global_position : SaveVector2

# Overridden Methods -----------------------------------------------------------


func _ready() -> void:
	_set_save_variables()
	_connect_signals()


func _process(_delta: float) -> void:
	if save_global_position.value != global_position:
		save_global_position.value = global_position


func _input(event: InputEvent) -> void:
	_inventory_input(event)
	_attack_input(event)


func _exit_tree() -> void:
	_free_save_variables()


# SaveVariable -----------------------------------------------------------------

func _set_save_variables() -> void:
	save_global_position = SaveVector2.new()
	save_global_position.init("player_position", Vector2(87.0, 50.0))


func _on_variables_loaded_from_file() -> void:
	global_position = save_global_position.value


func _free_save_variables() -> void:
	save_global_position.delete()


# Movement ---------------------------------------------------------------------

func _enable_walking() -> void:
	movement.can_move = true


func _disable_walking() -> void:
	movement.can_move = false


# Signals ----------------------------------------------------------------------

func _connect_signals() -> void:
	# load all the variables after the 'SaveLoad.load_variables()' function call in main_2.tscn _ready()
	SaveLoad.variables_loaded_from_file.connect(_on_variables_loaded_from_file)
	
	# remove any items from the inventory when given to an npc
	# through Dialogue Manager
	Village1.gave_item.connect(inventory.empty_slot_by_name)
	
	inventory.equip_item.connect(_on_inventory_equip_item)
	inventory.drop_item.connect(_on_inventory_drop_item)
	
	pickupable_item_area.item_pickup.connect(_on_pickupable_item_pickup)
	
	dialogue_area.dialogue_state.connect(_on_dialogic_area_dialogue_state)
	
	animation_player.animation_finished.connect(_on_animation_player_animation_finished)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	_attack_animation(anim_name)


func _on_dialogic_area_dialogue_state(in_dialogue : bool) -> void:
	if in_dialogue:
		_disable_walking()
		_disable_attacking()
	else:
		_enable_walking()
		if equipable_weapon.texture:
			_enable_attacking()


# Combat -----------------------------------------------------------------------

func _attack_input(event: InputEvent) -> void:
	# attack when the left mouse button is pressed
	# don't attack if already attacking
	# don't attack while inventory is open
	if attacking or not event is InputEventMouseButton:
		return
	
	# left mouse button presed
	if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if not inventory.visible:
			_attack()


func _attack_animation(anim_name: StringName) -> void:
	if anim_name == "swing":
		_enable_attacking()
		_enable_walking()
		attack_box_collision_box.disabled = true
		animation_player.play("weapon_idle")


func _attack() -> void:
	_disable_attacking()
	_disable_walking()
	attack_box_collision_box.disabled = false
	animation_player.play("swing")
	attack_box.look_at(get_global_mouse_position())
	print("attack.")


func _enable_attacking() -> void:
	attacking = false


func _disable_attacking() -> void:
	attacking = true


func _equip_weapon(new_weapon : Weapon) -> void:
	_enable_attacking()
	weapon = new_weapon
	if new_weapon.texture:
		equipable_weapon.texture = new_weapon.texture


func _unequip_weapon() -> void:
	_disable_attacking()
	weapon = null
	equipable_weapon.texture = null


# Inventory --------------------------------------------------------------------

func _inventory_input(event: InputEvent) -> void:
	# toggle the inventorys visibilty 
	if event.is_action_pressed("inventory"):
		inventory.visible = not inventory.visible
#		print("inventory is%svisible." % [" " if inventory.visible else " not "])
	pass


func _on_inventory_drop_item(slot_data : InventorySlotData) -> void:
	var pickupable : PickupableItem = _pickupable_item_res.instantiate()
	var item : ItemData = slot_data.item
	pickupable.position = global_position
	pickupable.item = item
	pickupable.quantity = slot_data.quantity
	get_parent().add_child(pickupable)
	
	print("dropped %s." % [item.name])
	
	# unequipe equiped items
	if weapon and item is EquipableItem and weapon == item:
		_unequip_weapon()


func _on_inventory_equip_item(item : EquipableItem) -> void:
	if item is Weapon:
		if item == weapon:
			_unequip_weapon()
		else:
			_equip_weapon(item as Weapon)


# PickupableItem ---------------------------------------------------------------

func _on_pickupable_item_pickup(pickupable_item : PickupableItem)-> void:
	# add item to inventory
	inventory.add_item(pickupable_item)


# ------------------------------------------------------------------------------
