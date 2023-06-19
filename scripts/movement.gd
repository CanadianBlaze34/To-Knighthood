class_name Movement extends Node

@export var speed : float = 300.0
@export var character : CharacterBody2D

var can_move : bool = true

func _ready() -> void:
	_set_character()


func _set_character() -> void:
	if not character:
		var parent : Node = get_parent()
		if parent is CharacterBody2D:
			character = parent as CharacterBody2D
			push_warning("%ss parent has been set as the character on ready." % [name])
		else:
			push_error("%ss character is null." % [name])


func _physics_process(_delta: float) -> void:
	if not can_move:
		return
	
	# Get the input direction and handle the movement/deceleration.
	var direction : Vector2 = Input.get_vector("walk_left", "walk_right",
		"walk_up", "walk_down")
	
	character.velocity = direction * speed
	
	
	var _collided : bool = character.move_and_slide()

