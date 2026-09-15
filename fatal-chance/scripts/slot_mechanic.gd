extends Control

#number of items in the slot
@export var n_options: int = 3
#references to the color rect nodes
@export var spinners: Array[Control]
#array of int that tells us the index of each slot and then a tween that stores the previous
var values: Array; var tween: Tween

func _ready() -> void:
	#check_rolls()
	pass

func spin():
	#compute values for each slot
	values = []
	#calculating time
	var spin_step = 1.0 / float(n_options)
	var offsets = {}
	#for each color rect in our exported array, you get a value between 0 and our number of items minus one
	#this is index number
	#add it to values array
	for s in spinners:
		values.append(randi_range(0, n_options - 1))
		#store the y offset so that the animation knows its bounds
		#adding three to have the slots spin alottt
		offsets[s] = { 'from': s.material.get_shader_parameter('y_offset'), 'to': 3.0 + values[-1] * spin_step}
	
	#stops previously running tweens by killing
	if tween: tween.kill()
	tween = get_tree().create_tween()
	#the tween will run for the (x, x, X) duration, going from the (X, x, x) value to the (x, X, x) value
	tween.tween_method(func (v):
		for s in spinners:
			s.material.set_shader_parameter('y_offset', lerpf(offsets[s].from, offsets[s].to, v)), 
		0.0, 1.0, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	#ensures that when the tween is finished rolling the slots will be set perfectly to their final offsets
	#no parameters such as the v
	print(offsets)
	print(values)

	tween.tween_callback(func ():
		for idx in spinners.size():
			spinners[idx].material.set_shader_parameter('y_offset', values[idx] * spin_step))
	#this makes it so that the spinning continues to be fast, recomputing the number to be close to wherever the image is at
		#for s in spinners:
		#s.material.set_shader_parameter('y_offset', offsets[s].to))
	
func check_attack() -> int:
	var special_attack_
	match values:
		[0, _, _]:
			special_attack_ = 0
		[1, _, _]:
			special_attack_ = 1
		[2, _, _]:
			special_attack_ = 2
	return special_attack_
	
func check_rolls() -> int:
	var damage =  0
	match values:
		[0, 0, 0]:
			print("all bites")
			damage = 30
		[0, 0, _]:
			print("two bite & random")
			damage = 15
		[0, _, _]:
			print("one bite & random")
			damage = 10
		[1, 1, 1]:
			print("all heads")
			damage = 30
		[1, 1, _]:
			print("two head & random")
			damage = 15
		[1, _, _]:
			print("one head & random")
			damage = 10
		[2, 2, 2]:
			print("all flames")
			damage = 30
		[2, 2, _]:
			print("two flames & random")
			damage = 15
		[2, _, _]:
			print("one flame & random")
			damage = 10
	return damage
