extends State

@export var move_state : State
@export var jump_state : State
@export var attack_state : State

func enter() -> void:
	super()
	parent.velocity.x = 0
	pass # Replace with function body.

func process_input(event: InputEvent) -> State:
	if parent.is_in_group("p_1"):
		print("PLAYER1")
		if Input.is_action_just_pressed('jump_p1') and parent.is_on_floor():
			return jump_state
		if Input.is_action_just_pressed('left_p1') or Input.is_action_just_pressed('right_p1'):
			return move_state
	if parent.is_in_group("p_2"):
		print("PLAYER2")
		if Input.is_action_just_pressed('jump_p2') and parent.is_on_floor():
			return jump_state
		if Input.is_action_just_pressed('left_p2') or Input.is_action_just_pressed('right_p2'):
			return move_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	
	return null
