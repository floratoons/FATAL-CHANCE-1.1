extends Node
class_name State

@export
var animation_name: String
@export
var move_speed: float = 300

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

# Hold a reference to the parent so that it can be controlled by the state
var parent = get_parent()

func enter() -> void:
	print("STATE PRINT PARENT: ", parent)
	var animation_player = get_tree().get_first_node_in_group("animationplayer")
	animation_player.play(animation_name)

func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	return null
