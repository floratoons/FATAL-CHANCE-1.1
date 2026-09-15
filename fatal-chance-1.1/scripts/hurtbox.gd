class_name Hurtbox
extends Area2D

func _init() -> void:
	#will interact with the hitboxes on layer 2
	collision_layer = 0
	collision_mask = 2
	
func _ready() -> void:
	#connects a signal to the area2d
	self.area_entered.connect(_on_area_entered)
	
func _on_area_entered(hitbox: FrameData) -> void:
	if hitbox == null:
		return
		
	#the owner is the top root node
	#checking if the player controllers have the "send_damage" function
	#if they have it then call the function with the hitbox's damage number
	if owner.has_method("send_damage"):
		owner.send_damage(hitbox.damage)
