extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	animated_sprite_2d.play("idle")
	pass

func _physics_process(delta: float) -> void:
	#look_at_other_player()
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump_p1") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left_p1", "right_p1")
	if direction:
		velocity.x = direction * SPEED
		animated_sprite_2d.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
