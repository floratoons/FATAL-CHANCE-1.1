extends Camera2D

var p_1
var p_2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	p_1 = get_tree().get_first_node_in_group("p_1")
	p_2 = get_tree().get_first_node_in_group("p_2")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	cam_follow(delta)

func cam_follow (delta: float) -> void:
	var center_pos : Vector2 = p_1.global_position.lerp(p_2.global_position, 0.5)
	
	position.x = center_pos.x
