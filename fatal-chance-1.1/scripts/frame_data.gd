class_name FrameData
extends Area2D

@export var damage : int
@export var knockback_force : int

func _init() -> void:
	#sets the hitbox to layer 2, which will be our hitbox layer
	#turns off collision mask
	collision_layer = 2
	collision_mask = 0
