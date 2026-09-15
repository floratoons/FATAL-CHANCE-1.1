extends Node2D
class_name level_manager

#@onready var p_1 = get_tree().get_nodes_in_group("p_1")
#@onready var p_2 = get_tree().get_nodes_in_group("p_2")

var mainCam = preload("res://scenes/main_camera.tscn")
const MAINCAM_SPEED = 150.0
var p_1
#get_tree().get_nodes_in_group("p_1")[0]
var p_2

#characters to load
var load_player1 = preload("res://scenes/player1_CONTROLLER.tscn")
var load_player2 = preload("res://scenes/player_2_CONTROLLER.tscn")
var player1_instance
var player2_instance

@onready var round_timer = $CanvasLayer/Timer/RoundTimer
@onready var sticker_manager = $CanvasLayer/StickerManager

@onready var text_animation_player = $TextAnimationPlayer

@onready var soul_meter_animation_player = $SoulMeterAnimationPlayer
@onready var pause_screen = $CanvasLayer/PauseScreen

var round_counter = 0



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneTransition.fade_out()
	load_players()
	p_1 = get_tree().get_first_node_in_group("p_1")
	p_2 = get_tree().get_first_node_in_group("p_2")
	#instantiate camera to the p_1 in the tree
	var instance = mainCam.instantiate()
	p_1.add_child(instance)
	#add_child(instance)
	var player1_pos = p_1.global_position
	instance.global_position = player1_pos
	
	print("p_1 name: " + p_1.name)
	
	pause_screen.hide()
	
	#character splash
	if GlobalData.p1_character == "Anathema":
		$CanvasLayer/SplashBackgroundBlankP1/AnathemaSplash.modulate = Color.WHITE
	if GlobalData.p1_character == "Talisman":
		$CanvasLayer/SplashBackgroundBlankP1/TalismanSplashArt.modulate = Color.WHITE
	
	if GlobalData.p2_character == "Anathema":
		$CanvasLayer/SplashBackgroundBlankP2/AnathemaSplash.modulate = Color.WHITE
	if GlobalData.p2_character == "Talisman":
		$CanvasLayer/SplashBackgroundBlankP2/TalismanSplashArt2.modulate = Color.WHITE
	
	start_round_intro()
	
	
func start_round_intro() -> void:
	# dont active input
	p_1.set_process_input(false)
	p_2.set_process_input(false)
	
	var label = $CanvasLayer/ReadySetFightAnnouncer
	await get_tree().create_timer(1).timeout
	get_tree().paused = true
	text_animation_player.play("RoundOneStart")
	await get_tree().create_timer(7).timeout
	get_tree().paused = false
	$SlotsAnimationPlayer.play("slots_slam")
	
	#label.text = "Ready..."
	#label.add_theme_font_size_override("font_size", 45)
	#label.visible = true
	#await get_tree().create_timer(2).timeout
	
	#label.text = "FIGHT!"
	#label.add_theme_font_size_override("font_size", 70)
	#await get_tree().create_timer(1).timeout
	
	#label.visible = false
	
	#active input
	p_1.set_process_input(true)
	p_2.set_process_input(true)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	check_health_timer_reset()
	check_for_slots()
	#set_cam_pos(delta)
	
	if Input.is_action_pressed("pause"):
		get_tree().paused = !get_tree().paused
		pause_screen.show()
		
		
		
		pass
	
	pass

func _physics_process(delta: float) -> void:
	look_at_enemy()

func look_at_enemy():
	#create a controller scene that controls inputs and then create a sprite scene for each character that is then loaded into the character controller scene
	#make this more variable instead of basing it off of node name//its not working ->
	#it isn't finding the variable and is coming up with a null
	if p_2.position.x > p_1.position.x:
		p_2.get_node("player2_LOADEDANIMS/Sprite2D").flip_h = true
		p_1.get_node("player1_LOADEDANIMS/Sprite2D").flip_h = false
		p_1.get_node("Hurtbox").scale.x = 1
		p_2.get_node("Hurtbox").scale.x = -1
		p_1.get_node("player1_LOADEDANIMS/Sprite2D/FrameData").scale.x = 1
		p_2.get_node("player2_LOADEDANIMS/Sprite2D/FrameData").scale.x = -1
		p_1.get_node("player1_LOADEDANIMS/Sprite2D/FrameData2").scale.x = 1
		p_2.get_node("player2_LOADEDANIMS/Sprite2D/FrameData2").scale.x = -1
		p_1.get_node("player1_LOADEDANIMS/Sprite2D/FrameDataSpecial1").scale.x = 1
		p_2.get_node("player2_LOADEDANIMS/Sprite2D/FrameDataSpecial1").scale.x = -1
		p_1.get_node("player1_LOADEDANIMS/Sprite2D/FrameDataSpecial2").scale.x = 1
		p_2.get_node("player2_LOADEDANIMS/Sprite2D/FrameDataSpecial2").scale.x = -1
		p_1.get_node("player1_LOADEDANIMS/Sprite2D/FrameDataSpecial3").scale.x = 1
		p_2.get_node("player2_LOADEDANIMS/Sprite2D/FrameDataSpecial3").scale.x = -1
	else:
		p_2.get_node("player2_LOADEDANIMS/Sprite2D").flip_h = false
		p_1.get_node("player1_LOADEDANIMS/Sprite2D").flip_h = true
		p_1.get_node("Hurtbox").scale.x = -1
		p_2.get_node("Hurtbox").scale.x = 1
		p_1.get_node("player1_LOADEDANIMS/Sprite2D/FrameData").scale.x = -1
		p_2.get_node("player2_LOADEDANIMS/Sprite2D/FrameData").scale.x = 1
		p_1.get_node("player1_LOADEDANIMS/Sprite2D/FrameData2").scale.x = -1
		p_2.get_node("player2_LOADEDANIMS/Sprite2D/FrameData2").scale.x = 1
		p_1.get_node("player1_LOADEDANIMS/Sprite2D/FrameDataSpecial1").scale.x = -1
		p_2.get_node("player2_LOADEDANIMS/Sprite2D/FrameDataSpecial1").scale.x = 1
		p_1.get_node("player1_LOADEDANIMS/Sprite2D/FrameDataSpecial2").scale.x = -1
		p_2.get_node("player2_LOADEDANIMS/Sprite2D/FrameDataSpecial2").scale.x = 1
		p_1.get_node("player1_LOADEDANIMS/Sprite2D/FrameDataSpecial3").scale.x = -1
		p_2.get_node("player2_LOADEDANIMS/Sprite2D/FrameDataSpecial3").scale.x = 1
	
func load_players():
	player1_instance = load_player1.instantiate()
	player2_instance = load_player2.instantiate()
	var marker1_pos = $p_1Marker2D.global_position
	var marker2_pos = $p_2Marker2D.global_position
	add_child(player1_instance)
	add_child(player2_instance)
	player1_instance.global_position = marker1_pos
	player2_instance.global_position = marker2_pos

func reset_players():
	print("reset players getting called")
	var marker1_pos = $p_1Marker2D.global_position
	var marker2_pos = $p_2Marker2D.global_position
	player1_instance.global_position = marker1_pos
	player2_instance.global_position = marker2_pos
	
	sticker_reset()
	
	p_1.soul_meter.value = 0
	p_2.soul_meter.value = 0
	soul_meter_animation_player.stop()
	$CanvasLayer/SoulMeterFullP1.hide()
	$CanvasLayer/SoulMeterFullP2.hide()
	
	#add starts here
	#await get_tree().create_timer(0.25).timeout
	#get_tree().paused = true
	#await get_tree().create_timer(1).timeout
	#get_tree().paused = false
	await get_tree().create_timer(1).timeout
	get_tree().paused = true
	#replace with round 2 when instead
	text_animation_player.play("round_2_start")
	await get_tree().create_timer(5).timeout
	get_tree().paused = false

#func set_cam_pos(delta):
#	var middle_pos = (p_1.global_position.x + p_2.global_position.x) * 0.5
#	print(middle_pos)
#	$MainCamera.global_position.x = lerp($MainCamera.global_position.x, middle_pos, MAINCAM_SPEED * delta)

func check_health_timer_reset():
	#print("p2 health: " + str(p_2.p_2_current_health))
	if p_1.p_1_current_health <= 0:
		round_counter += 1
		await get_tree().create_timer(0.25).timeout
		get_tree().paused = true
		text_animation_player.play("ko_animation")
		await get_tree().create_timer(2).timeout
		get_tree().paused = false
		print("p1 lose, timer reset")
		round_timer.set_wait_time(100)
		round_timer.start()
		$CanvasLayer/Timer.reset_timer()
		if p_1.lives_lost < 2 && p_2.lives_lost < 2:
			reset_players()

	if p_2.p_2_current_health <= 0:
		round_counter += 1
		await get_tree().create_timer(0.25).timeout
		get_tree().paused = true
		text_animation_player.play("ko_animation")
		await get_tree().create_timer(2).timeout
		get_tree().paused = false
		print("p2 lose, timer reset")
		round_timer.set_wait_time(100)
		round_timer.start()
		$CanvasLayer/Timer.reset_timer()
		if p_1.lives_lost < 2 && p_2.lives_lost < 2:
			reset_players()


func _on_round_timer_timeout() -> void:
	print("round over")
	if(p_1.p_1_current_health > p_2.p_2_current_health):
		round_counter += 1
		print("p1 wins")
		#round_timer.time = 7
		await get_tree().create_timer(0.25).timeout
		get_tree().paused = true
		text_animation_player.play("ko_animation")
		await get_tree().create_timer(2).timeout
		p_2.send_damage(100)
		round_timer.set_wait_time(100)
		round_timer.start()
		$CanvasLayer/Timer.reset_timer()
		if p_1.lives_lost < 2 && p_2.lives_lost < 2:
			reset_players()
	elif (p_1.p_1_current_health < p_2.p_2_current_health):
		round_counter += 1
		await get_tree().create_timer(0.25).timeout
		get_tree().paused = true
		text_animation_player.play("ko_animation")
		await get_tree().create_timer(2).timeout
		p_1.send_damage(100)
		round_timer.set_wait_time(100)
		round_timer.start()
		$CanvasLayer/Timer.reset_timer()
		if p_1.lives_lost < 2 && p_2.lives_lost < 2:
			reset_players()
	else:
		round_counter += 1
		round_timer.set_wait_time(100)
		round_timer.start()
		$CanvasLayer/Timer.reset_timer()
		if p_1.lives_lost < 2 && p_2.lives_lost < 2:
			reset_players()

func check_for_slots():
	#checking if slots can roll
	if p_1.soul_meter.value >= 100:
		p_2.can_use_slot = true
		soul_meter_animation_player.play("p2_meter_full")
		#p_1.soul_meter.get("theme_overrides_styles/fill").bg_color = Color(1.0, 0.929, 0.0, 1.0)
	if p_2.soul_meter.value >= 100:
		p_1.can_use_slot = true
		soul_meter_animation_player.play("p1_meter_full")
		#p_2.soul_meter.get("theme_overrides_styles/fill").bg_color = Color(1.0, 0.929, 0.0, 1.0)
	
	#checking if slots have rolled
	if p_1.slots_have_rolled == true:
		p_2.soul_meter.value = 0
		p_1.can_use_slot = false
		p_1.slots_have_rolled = false
		soul_meter_animation_player.stop()
		$CanvasLayer/SoulMeterFullP1.hide()
		
		pass
	if p_2.slots_have_rolled == true:
		p_1.soul_meter.value = 0
		p_2.can_use_slot = false
		p_1.slots_have_rolled = false
		soul_meter_animation_player.stop()
		$CanvasLayer/SoulMeterFullP2.hide()
		
	pass

func sticker_reset():
	p_1.hits_in_a_row = 0
	p_2.hits_in_a_row = 0

	for s in sticker_manager.p_1_sticker_pile.get_children():
		if s != null:
			sticker_manager.p_1_sticker_pile.remove_child(s)
			s.queue_free()
		pass
	for s in sticker_manager.p_2_sticker_pile.get_children():
		if s != null:
			sticker_manager.p_1_sticker_pile.remove_child(s)
			s.queue_free()
		pass
	for s in sticker_manager.p_1_sticker_path.get_children():
		if s != null:
			sticker_manager.p_1_sticker_pile.remove_child(s)
			s.queue_free()
		pass
	for s in sticker_manager.p_2_sticker_path.get_children():
		if s != null:
			sticker_manager.p_1_sticker_pile.remove_child(s)
			s.queue_free()
		pass
	pass
