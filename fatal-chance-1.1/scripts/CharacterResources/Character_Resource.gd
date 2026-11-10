extends Resource
class_name characters

@export var character_name : String
@export var anim_scene : Resource
@export var moveset : Moveset

#load in your other character properties that you want standardized
#making an autoload

static func _loadResource():
	pass

func _init() -> void:
	if character_name == "Anathema":
		print("Anathema")
		pass
