extends Node

@onready var fade_to_black: ColorRect = $CanvasLayer30/FadeToBlack
@onready var animation_player: AnimationPlayer = $AnimationPlayer

## Initialization
func _ready() -> void:
	fade_to_black.hide()
	
	
func fade_out() -> void:
	fade_to_black.show()
	animation_player.play("SceneTransition")
	
	await animation_player.animation_finished
	fade_to_black.hide()
	
	
func fade_in() -> void:
	fade_to_black.show()
	animation_player.play_backwards("SceneTransition")
	
	await animation_player.animation_finished
	fade_to_black.hide()
