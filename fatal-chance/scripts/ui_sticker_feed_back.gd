extends Control

@onready var p_1_sticker_path = $p_1_sticker_path/PathFollow2D
@onready var p_2_sticker_path = $p_2_sticker_path/PathFollow2D

var two_combo_sticker = preload("res://scenes/UI/Combo2Sticker.tscn")
var three_combo_sticker = preload("res://scenes/UI/Combo3Sticker.tscn")
var four_combo_sticker = preload("res://scenes/UI/Combo4Sticker.tscn")
var five_combo_sticker = preload("res://scenes/UI/Combo5Sticker.tscn")

@onready var animator = $AnimationPlayer

var temp_sticker

@onready var p_1_sticker_pile = $p_1_StickerPile
@onready var p_2_sticker_pile = $p_2_StickerPile

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	p_2_sticker_path.rotation = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func add_sticker_p_1(feedback : String):
	if feedback == "two" :
		temp_sticker = two_combo_sticker.instantiate()
		pass
	elif  feedback == "three" :
		temp_sticker = three_combo_sticker.instantiate()
		pass
	elif feedback == "four":
		temp_sticker = four_combo_sticker.instantiate()
	elif feedback == "five":
		temp_sticker = five_combo_sticker.instantiate()
	elif feedback == "counter" :
		pass
	
	p_1_sticker_path.progress_ratio = 0
	p_1_sticker_path.add_child(temp_sticker)
	print(temp_sticker.rotation)
	
	animator.play("p_1_sticker_slam")
	pass

func add_sticker_p_2(feedback : String):

	if feedback == "two" :
		temp_sticker = two_combo_sticker.instantiate()
		pass
	elif  feedback == "three" :
		temp_sticker = three_combo_sticker.instantiate()
		pass
	elif feedback == "counter" :
		pass
	
	p_2_sticker_path.progress_ratio = 0
	p_2_sticker_path.add_child(temp_sticker)
	print(temp_sticker.rotation)
	
	animator.play("p_2_sticker_slam")
	pass

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "p_1_sticker_slam":
		p_1_sticker_path.remove_child(temp_sticker)
		p_1_sticker_pile.add_child(temp_sticker)
		temp_sticker.rotation = deg_to_rad(randf_range(-15, 15))
		
	if anim_name == "p_2_sticker_slam":
		p_2_sticker_path.remove_child(temp_sticker)
		p_2_sticker_pile.add_child(temp_sticker)
		temp_sticker.rotation = deg_to_rad(randf_range(-15, 15))
		pass
	pass # Replace with function body.
