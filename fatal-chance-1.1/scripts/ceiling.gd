extends Area2D

var push_down = Vector2.DOWN
var push_force: float = 1600

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#body_entered.connect(_on_body_entered)
	pass # Replace with function body.

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.has_method("apply_impulse"):
		print(body)
		print("pushed down")
		var push_velocity = push_down.normalized() * push_force
		body.apply_impulse(push_velocity)
