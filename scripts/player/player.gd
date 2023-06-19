class_name Player extends CharacterBody2D

@export var weapon : Weapon

@onready var inventory: Inventory = $UI/Inventory
@onready var _pickupable_item_res := preload("res://scenes/pickupable_item.tscn")
@onready var equipable_weapon: Sprite2D = $EquipableWeapon
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_box: Area2D = $AttackBox
@onready var attack_box_collision_box: CollisionShape2D = $AttackBox/CollisionShape2D
var attacking : bool = true

@onready var movement: Movement = $movement


var save_global_position : SaveVector2

func _ready() -> void:
	save_global_position = SaveVector2.new()
	save_global_position.init("player_position", Vector2(87.0, 50.0))
	# remove any items from the inventory when given to an npc
	# through Dialogue Manager
	Village1.gave_item.connect(inventory.remove_item_by_name)
	SaveLoad.loaded.connect(func (): global_position = save_global_position.value)


func _input(event: InputEvent) -> void:
	# toggle the inventorys visibilty 
	if event.is_action_pressed("inventory"):
		inventory.visible = not inventory.visible
#		print("inventory is%svisible." % [" " if inventory.visible else " not "])
	
	# attack when the left mouse button is pressed
	# don't attack if already attacking
	# don't attack while inventory is open
	elif not attacking and event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT:
			if not inventory.visible:
				_attack()


func _attack() -> void:
	_disable_attacking()
	_disable_walking()
	attack_box_collision_box.disabled = false
	animation_player.play("swing")
	attack_box.look_at(get_global_mouse_position())
	print("attack.")


func _on_pickupable_item_pickup(pickupable_item : PickupableItem)-> void:
	# add item to inventory
	inventory.add_item(pickupable_item.item)


func _on_inventory_drop_item(item : Item) -> void:
	var pickupable : PickupableItem = _pickupable_item_res.instantiate()
	pickupable.position = global_position
	pickupable.item = item
	get_parent().add_child(pickupable)
	
	print("dropped %s." % [item.name])
	
	# unequipe equiped items
	if item is EquipableItem:
		if item.equiped and item.texture == equipable_weapon.texture:
			equipable_weapon.texture = null
			item.equiped = false


func _on_inventory_equip_item(item : EquipableItem) -> void:
	if item is Weapon:
		if item == weapon:
			_unequip_weapon()
			item.equiped = false
		else:
			_equip_weapon(item as Weapon)
			item.equiped = true


func _equip_weapon(new_weapon : Weapon) -> void:
	_enable_attacking()
	weapon = new_weapon
	if new_weapon.texture:
		equipable_weapon.texture = new_weapon.texture


func _unequip_weapon() -> void:
	_disable_attacking()
	equipable_weapon.texture = null


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "swing":
		_enable_attacking()
		_enable_walking()
		attack_box_collision_box.disabled = true
		animation_player.play("weapon_idle")


func _enable_walking() -> void:
	movement.can_move = true


func _disable_walking() -> void:
	movement.can_move = false


func _enable_attacking() -> void:
	attacking = false


func _disable_attacking() -> void:
	attacking = true


func _on_dialogic_area_dialogue_state(in_dialogue : bool) -> void:
	if in_dialogue:
		_disable_walking()
		_disable_attacking()
	else:
		_enable_walking()
		_enable_attacking()


