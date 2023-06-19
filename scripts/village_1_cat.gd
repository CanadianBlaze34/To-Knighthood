class_name Village1Cat extends CharacterBody2D

func _ready() -> void:
	connect_signal()


func connect_signal() -> void:
	Village1.found_cat.connect(queue_free)
