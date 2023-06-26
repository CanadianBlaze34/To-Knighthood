class_name Village1Cat extends CharacterBody2D

func _ready() -> void:
	if Village1Autoload.spawn_ashleys_cat():
		connect_signal()
	else:
		queue_free()


func connect_signal() -> void:
	Village1Autoload.found_cat.connect(queue_free)
