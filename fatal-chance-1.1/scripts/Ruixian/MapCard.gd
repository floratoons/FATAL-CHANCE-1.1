extends Area2D

@export var map_scene : String = ""

@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer

func _ready():
	SceneTransition.fade_out()
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	input_pickable = true
	

func _on_mouse_entered():
	print("mouse entered!")
	anim.play("hover")
	sprite.material.set_shader_parameter("show_outline", true)

func _on_mouse_exited():
	anim.play_backwards("hover") 
	sprite.material.set_shader_parameter("show_outline", false)

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			get_node("/root/Node2D/ClickSound").play()
			await SceneTransition.fade_in()
			get_tree().change_scene_to_file("res://scenes/fighting_level.tscn")
