extends Resource
class_name characters

@export var character_name : String
@export var character_sprite : Texture2D
@export var anim_scene : Resource

#load in your other character properties that you want standardized
#making an autoload

func _loadResource():
	pass
