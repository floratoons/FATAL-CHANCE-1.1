class_name Pushbox
extends Area2D

var push_down = Vector2.DOWN
var push_force: float = 800
var push_dir
var push_left = Vector2.LEFT
var push_right = Vector2.RIGHT

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#body_entered.connect(_on_body_entered)
	pass # Replace with function body.

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.has_method("apply_impulse"):
		print(body)
		print("pushed down")
		if body is CharacterBody2D and body.dir == -1:
			push_dir = push_left
		if body is CharacterBody2D and body.dir == 1:
			push_dir = push_right
		var push_velocity = push_down.normalized() + push_dir.normalized() * push_force
		body.apply_impulse(push_velocity)
