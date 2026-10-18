@tool #to test it in editor
extends Node2D

class_name HorisontalUI

#spacing between children in menu
@export var spacing: float = 20
#menu has to wrap vertically so
@export var wraparound_radius: float = 300
@export var wraparound_height: float = 50
#visibility variables
@export_range(0.0, 1.0) var opacity_strength: float = 0.35
@export_range(0.0, 1.0) var scale_strength: float = 0.25
@export_range(0.01, 0.99, 0.01) var scale_min: float = 0.1

#how fast the children fade out if not selected
@export var smoothing_speed: float = 6.5
#the currently active child
@export var selected_index: int = 0
#bool to follow the selected child
@export var follow_button_focus: bool = false
#the position of the selected node
@export var position_offset: Control 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#check if there are children in position offset,  if not -> stop the code from executing
	if !position_offset or position_offset.get_child_count() == 0:
		return
	
	selected_index = clamp(selected_index, 0, position_offset.get_child_count()-1)
	
	for i in position_offset.get_children():
		#math for the 3d effect
		var max_index_range = max(1, (position_offset.get_child_count() -1) / 2.0)
		var angle = clamp((i.get_index() - selected_index) / max_index_range, -1.0, 1.0) * PI
		var x = sin(angle) * wraparound_radius
		var y = cos(angle) * wraparound_height
		var target_pos = Vector2(x, y - wraparound_height) - i.size/2.0
		i.position = lerp(i.position, target_pos, smoothing_speed * delta)
		
		#controlling the scale based on pivot
		i.pivot_offset = i.size/2.0
		var target_scale = 1.0 - (scale_strength * abs(i.get_index()-selected_index))
		target_scale = clamp(target_scale, scale_min, 1.0)
		i.scale = lerp(i.scale, Vector2.ONE * target_scale, smoothing_speed*delta)
		
		#controlling opacity 
		#i.modulate.a is the opacity of the node
		var target_opacity = 1.0 - (opacity_strength * abs(i.get_index()-selected_index))
		target_opacity = clamp(target_opacity, 0.0, 1.0)
		i.modulate.a = lerp(i.modulate.a, target_opacity, smoothing_speed*delta)
		
		#check if this is the selected child based on position
		if i.get_index() == selected_index:
			i.z_index = 1
			#allow mouse and key input for the child
			i.mouse_filter = Control.MOUSE_FILTER_STOP
			i.focus_mode = Control.FOCUS_ALL
		else:
			i.z_index = -abs(i.get_index()-selected_index)
			#disable the unselected children for input
			i.mouse_filter = Control.MOUSE_FILTER_IGNORE
			i.focus_mode = Control.FOCUS_NONE
		if follow_button_focus and i.has_focus():
			selected_index = i.get_index()
	
	
	#lerp to 0 on the x axis i think
	position_offset.position.x = lerp(position_offset.position.x, 0.0, smoothing_speed*delta)
