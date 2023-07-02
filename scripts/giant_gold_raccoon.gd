class_name GiantGoldenRaccoon extends Entity

var target : Node2D : set = set_target
var path_find : bool = false
var _can_attack : bool = false

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var attack_box: Area2D = $AttackBox
@onready var attack_box_collision_box: CollisionShape2D = $AttackBox/CollisionShape2D
@onready var attack_speed: Timer = $AttackSpeed

var speed : float = 20.0
var attack_range : float = 24.0

signal hit(node : Node2D)

func _ready() -> void:
#	navigation_agent_2d.max_speed = speed
	navigation_agent_2d.path_desired_distance = 3.0
	navigation_agent_2d.target_desired_distance = attack_range


func set_target(new_target : Node2D) -> void:
	target = new_target
	path_find = target != null
	# reset variables
	if not path_find:
		_can_attack= false


func _physics_process(delta: float) -> void:
	
	if not path_find or is_queued_for_deletion():
		return
	
	# if close to target, attack
	if not _can_attack and navigation_agent_2d.distance_to_target() <= attack_range:
		_attack_target()
		return
	
	# move entity
	navigation_agent_2d.target_position = target.global_position
	
	var current_agent_position : Vector2 = global_position
	var next_path_position : Vector2 = navigation_agent_2d.get_next_path_position()
	
	var new_velocity : Vector2 = next_path_position - current_agent_position
	new_velocity = new_velocity.normalized()
	new_velocity *= speed
	
	global_position += new_velocity * delta
	


func _attack_target() -> void:
	print("GiantGoldenRaccoon::_attack_target")
	attack_box.look_at(target.global_position)
	attack_box_collision_box.disabled = false
	_can_attack = true
	attack_speed.start()


func _on_attack_speed_timeout() -> void:
	print("GiantGoldenRaccoon::_on_attack_speed_timeout")
	attack_box_collision_box.call_deferred("set_disabled", true)
	_can_attack = false


func _on_attack_box_area_entered(area: Area2D) -> void:
	print("GiantGoldenRaccoon::_on_attack_box_area_entered")
	attack_box_collision_box.call_deferred("set_disabled", true)
	hit.emit(area.get_parent())
