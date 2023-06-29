class_name SlimeFishEvent extends Node2D

@onready var area_2d: Area2D = $Area2D

var _player : Player = null
var _slime_puddle : Sprite2D

signal spawn_monster(entity : Entity)

func _ready() -> void:
	print("SlimeFishEvent::_ready")
	if MysteryForestAutoload.has_monk_1_quest_complete():
		queue_free()
	else:
		_connect_signals()


func _connect_signals() -> void:
	area_2d.body_entered.connect(_on_body_entered)
	area_2d.body_exited.connect(_on_body_exited)


func _disconnect_signals() -> void:
	area_2d.body_entered.disconnect(_on_body_entered)
	area_2d.body_exited.disconnect(_on_body_exited)


func _on_player_event()-> void:
	print("SlimeFishEvent::_on_player_event")
	_drop_slime_goo_on_ground()


func _drop_slime_goo_on_ground() -> void:
	var slime_goo_amount : int = _player.inventory.item_amount(PreloadItemsAutoload.slime_goo)
	if slime_goo_amount > 0:
		_player.inventory.remove_item_quantity(PreloadItemsAutoload.slime_goo, 1)
		
		# add slime to a pile on the ground and the more slime
		# added the bigger the pile gets
		if not _slime_puddle:
			_slime_puddle = Sprite2D.new()
			_slime_puddle.texture = preload("res://images/slime_puddles.png")
			_slime_puddle.name = "SlimePuddle"
			_slime_puddle.hframes = 5
			add_child(_slime_puddle)
		else:
			_slime_puddle.frame += 1
			
			# last frame of the sprite(frame 4, 0-4), has dropped hframes(5) amount of slime
			# spawn the slime fish once the player has put down 5 slime and remove the pile
			if _slime_puddle.frame == _slime_puddle.hframes - 1:
				
				_slime_puddle.queue_free()
				
				_spawn_slime_fish()
				
				_player.activate_event.disconnect(_on_player_event)
				_player = null
				
				_disconnect_signals()
				
				queue_free()
		
	else:
		print("SlimeFishEvent::_on_player_event: no slime_goo to place on the dock")


func _spawn_slime_fish() -> void:
	print("SlimeFishEvent::_spawn_fish")
	var slime_fish : SlimeFish = preload("res://scenes/slime_fish.tscn").instantiate()
	slime_fish.global_position = Vector2(896, 3208)
	spawn_monster.emit(slime_fish)


func _on_body_entered(body : Node2D)-> void:
	if not body is Player:
		return
	
	if body == _player:
		return
	
	print("SlimeFishEvent::_on_body_entered")
	
	_player = body
	_player.activate_event.connect(_on_player_event)


func _on_body_exited(body : Node2D)-> void:
	if not body is Player:
		return
	
	if body != _player:
		return
	
	print("SlimeFishEvent::_on_body_exited")
	
	
	_player.activate_event.disconnect(_on_player_event)
	_player = null
