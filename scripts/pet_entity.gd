class_name PetEntity extends Area2D


@export var entity : Entity


signal pet


var _player : Player = null


func _input(event: InputEvent) -> void:
	if not event.is_action_pressed("event") or _player == null:
		return
	
	print("%s has been petted." % [entity.name])
	StatsAutoload.petted(_get_entity_name())
	pet.emit()


func _get_entity_name() -> String:
	if entity is Raccoon:
		return "raccoon"
	
	if entity is Slime:
		return "slime"
	
	if entity is Skeleton:
		return "skeleton"
	
	return "unkown"


func _on_body_entered(body: Node2D) -> void:
	if not body is Player or body == _player:
		return
	
	_player = body as Player
	print("PetEntity::_on_body_entered: player set.")


func _on_body_exited(body: Node2D) -> void:
	if not body is Player or body != _player:
		return
	
	_player = null
	print("PetEntity::_on_body_exited: player is null.")
	
