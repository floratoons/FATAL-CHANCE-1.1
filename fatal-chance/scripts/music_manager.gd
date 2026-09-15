extends Node2D

@onready var level_bg_music = $BGMUSIC

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_tree().current_scene.scene_file_path == "res://scenes/fighting_level.tscn":
		level_bg_music.play(60.0)
		BgmPlayer.stop()
