extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed():
	$ClickSound.play()
	await SceneTransition.fade_in()
	get_tree().change_scene_to_file("res://scenes/Ruixian/Character_Selection_Scene.tscn")

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("jump_p1"):
		print("called")
		$CarouselUI.selected_index -= 1
		if $CarouselUI.selected_index < 0:
			$CarouselUI.selected_index += 1
	if Input.is_action_just_pressed("crouch_p1"):
		print("called")
		$CarouselUI.selected_index += 1
		#can change to 6 later
		if $CarouselUI.selected_index > 5:
			$CarouselUI.selected_index += 1
