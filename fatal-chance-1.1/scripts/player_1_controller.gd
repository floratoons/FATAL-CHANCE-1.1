extends CharacterBody2D

#characters to load
var anathema = preload("res://scenes/anathema_anims.tscn")
var talisman = preload("res://scenes/talisman_anims.tscn")

var anathema_stocks = preload("res://scenes/UI/AnathemaStocks.tscn")
var talisman_stocks = preload("res://scenes/UI/TalismanStocks.tscn")

var anathema_reel = preload("res://assets/prototype_reel.png")
var talisman_reel = preload("res://assets/talisman_reel.png")

var animation_player
var special_damage
var special_attack

var stocks
@onready var stock_marker = $CanvasLayer/StockMarker
var slot_machine
@onready var health_bar = $CanvasLayer/HealthBar
@onready var soul_meter = $CanvasLayer/SoulMeter

var can_use_slot = false
var slots_have_rolled = false

@export var health: int = 100
@export var p_1_current_health: int

@onready var p_2_combo_timer = $p_2ComboTimer
var hits_in_a_row = 0
var sticker_manager

var combo_timer := 0.0
var max_combo_delay := 1.0

var lives_lost = 0

@onready var text_marker = $CanvasLayer/TextMarker
var round_text = preload("res://scenes/UI/RoundText.tscn")

var text_animation_player


const SPEED = 300.0
const JUMP_VELOCITY = -750.0
const DASH_SPEED = 800.0
var moving: bool = false
var attacking: bool = false
var jumping: bool = false
var crouching: bool = false
var dashing: bool = false

var can_dash: bool = false
var can_crouch: bool = true
var can_attack1: bool = true
var can_attack2: bool = true
var can_special1: bool = false
var can_special2: bool = false
var can_special3: bool = false

func _ready() -> void:
	insert_player_anims()
	insert_player_stocks()
	#initialize the health bar 
	health_bar.init_health(100)
	soul_meter.value = 0
	#set the current health to total health and then set the healthbar
	p_1_current_health = health
	
	animation_player = get_tree().get_first_node_in_group("animationplayer")
	animation_player.animation_finished.connect(anim_done)
	print("animationplayer name: " + animation_player.name)
	animation_player.play("idle")
	
	slot_machine = get_tree().get_first_node_in_group("slotmachine")
	print("slotmachine name: " + slot_machine.name)
	
	sticker_manager = get_tree().get_first_node_in_group("stickermanager")
	print("sticker mager name: " + sticker_manager.name)
	
	text_animation_player = get_tree().get_first_node_in_group("textanimator")

	pass

func _physics_process(delta: float) -> void:
	combo_timer -= delta
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if not moving and not attacking and not jumping and is_on_floor():
		animation_player.play("idle")

	if not moving and not attacking and not jumping and can_crouch and Input.is_action_pressed("crouch_p1"):
		crouch()
		crouching = true

	dash()

	# Handle jump.
	if Input.is_action_just_pressed("jump_p1") and is_on_floor() and not attacking:
		velocity.y = JUMP_VELOCITY
		jumping = true
		can_dash = true
		animation_player.play("jump")

#attack functions
	if Input.is_action_just_pressed("A_p1") and not jumping and can_attack1 and not attacking:
		attacking = true
		animation_player.play("A1")
		attack_timer(0.75)

	if Input.is_action_just_pressed("B_p1") and not jumping and can_attack2 and not attacking:
		attacking = true
		animation_player.play("B1")
		attack_timer(.45)

	if can_special1 and Input.is_action_pressed("A_p1") and Input.is_action_just_pressed("B_p1") and not attacking:
		animation_player.play("RESET")
		attacking = true
		animation_player.play("S1")

	if can_special2 and Input.is_action_pressed("B_p1") and Input.is_action_just_pressed("C_p1") and not attacking:
		animation_player.play("RESET")
		attacking = true
		animation_player.play("S2")

	if can_special3 and Input.is_action_pressed("A_p1") and Input.is_action_just_pressed("C_p1") and not attacking:
		animation_player.play("RESET")
		attacking = true
		animation_player.play("S3")

	roll_slots()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left_p1", "right_p1")
	if direction:
		if dashing:
			velocity.x = direction * DASH_SPEED
		else:
			velocity.x = direction * SPEED
			moving = true
			if not attacking and not jumping and moving and is_on_floor():
				animation_player.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		moving = false

	move_and_slide()
	
	#print("Current Health: " + str(p_1_current_health))
	#print("Max Health: " + str(health))

func crouch():
	animation_player.play("crouch")
	print("crouching")
	await get_tree().create_timer(5).timeout
	can_crouch = false
	# Starts the timer
	await get_tree().create_timer(1).timeout
	can_crouch = true
	print("can crouch")

func dash():
	if Input.is_action_just_pressed("left_p1") and jumping and can_dash:
		dashing = true
		can_dash = false
		await get_tree().create_timer(0.3).timeout
		dashing = false
	if Input.is_action_just_pressed("right_p1") and jumping and can_dash:
		dashing = true
		can_dash = false
		await get_tree().create_timer(0.3).timeout
		dashing = false

func attack_timer(cooldown : int):
	can_attack1 = false
	can_attack2 = false
	# Starts the timer
	await get_tree().create_timer(cooldown).timeout
	can_attack1 = true
	can_attack2 = true
	print("can attack1")

func roll_slots():
	var is_combo = false
	
	if Input.is_action_just_pressed("crouch_p1"):
		if combo_timer > 0:
			is_combo = true
			combo_timer = 0.0
		else:
			combo_timer = max_combo_delay
	if Input.is_action_just_pressed("A_p1"):
		if combo_timer > 0:
			is_combo = true
			combo_timer = 0.0
		else:
			combo_timer = max_combo_delay

	if is_combo and Input.is_action_pressed("crouch_p1") and Input.is_action_just_pressed("A_p1") and can_use_slot == true:
		slots_have_rolled = true
		print(is_combo)
		var s1 = get_tree().get_nodes_in_group("slot1")
		var s2 = get_tree().get_nodes_in_group("slot2")
		var s3 = get_tree().get_nodes_in_group("slot3") 
		if GlobalData.p1_character == "Anathema":
			s1[0].material.set_shader_parameter('tex', anathema_reel)
			s2[0].material.set_shader_parameter('tex', anathema_reel)
			s3[0].material.set_shader_parameter('tex', anathema_reel)
			slot_machine.spin()
			print("Roll Slots")
			#changes the special damage to be whatever combo is rolled from the slots
			special_damage = slot_machine.check_rolls()
			#assigning a number value to each attack to later check if special_attack is that value to then activate the bool to attack
			special_attack = slot_machine.check_attack()
			print(special_damage)
			special_attack_assign()
			#$player1_LOADEDANIMS/Sprite2D/FrameData.damage = special_damage
		if GlobalData.p1_character == "Talisman":
			s1[0].material.set_shader_parameter('tex', talisman_reel)
			s2[0].material.set_shader_parameter('tex', talisman_reel)
			s3[0].material.set_shader_parameter('tex', talisman_reel)
			slot_machine.spin()
			print("Roll Slots")
			special_damage = slot_machine.check_rolls()
			special_attack = slot_machine.check_attack()
			print(special_damage)
			special_attack_assign()
			#$player1_LOADEDANIMS/Sprite2D/FrameData.damage = special_damage

func special_attack_assign():
	if special_attack == 0:
		can_special1 = true
		print("canS1")
		print(can_special1)
		$player1_LOADEDANIMS/Sprite2D/FrameDataSpecial1.damage = special_damage
	if special_attack == 1:
		can_special2 = true
		print("canS2")
		print(can_special2)
		$player1_LOADEDANIMS/Sprite2D/FrameDataSpecial2.damage = special_damage
	if special_attack == 2:
		can_special3 = true
		print("canS3")
		print(can_special3)
		$player1_LOADEDANIMS/Sprite2D/FrameDataSpecial3.damage = special_damage

func insert_player_anims():
	#if button pressed then insert specific character anims
	if GlobalData.p1_character == "Anathema":
		var anathema_instance = anathema.instantiate()
		$player1_LOADEDANIMS.add_child(anathema_instance)
		#grab the animation hitboxes
		anathema_instance.get_node("FrameData").collision_layer = 4
		anathema_instance.get_node("FrameData2").collision_layer = 4
		anathema_instance.get_node("FrameDataSpecial1").collision_layer = 4
		anathema_instance.get_node("FrameDataSpecial2").collision_layer = 4
		anathema_instance.get_node("FrameDataSpecial3").collision_layer = 4
	if GlobalData.p1_character == "Talisman":
		var talisman_instance = talisman.instantiate()
		$player1_LOADEDANIMS.add_child(talisman_instance)
		#grab the animation hitboxes
		talisman_instance.get_node("FrameData").collision_layer = 4
		talisman_instance.get_node("FrameData2").collision_layer = 4
		talisman_instance.get_node("FrameDataSpecial1").collision_layer = 4
		talisman_instance.get_node("FrameDataSpecial2").collision_layer = 4
		talisman_instance.get_node("FrameDataSpecial3").collision_layer = 4

func insert_player_stocks():
	#if character selction button pressed 
	if GlobalData.p1_character == "Anathema":
		stocks = anathema_stocks.instantiate()
	if GlobalData.p1_character == "Talisman":
		stocks = talisman_stocks.instantiate()

	
	stock_marker.add_child(stocks)

func send_damage(amount: int) -> void:
	if crouching:
		animation_player.stop
		can_crouch = false
		crouching = false
	else:
		p_1_current_health -= amount
		soul_meter.value += amount * 2.5
		print("Damage: ", amount)
		print("p_1current_health: ", + p_1_current_health)
		#on hit change color for now
		$player1_LOADEDANIMS/Sprite2D.self_modulate = Color.RED
		await get_tree().create_timer(.5).timeout
		$player1_LOADEDANIMS/Sprite2D.self_modulate = Color.WHITE
		
		hits_in_a_row += 1
		if hits_in_a_row == 2:
			print("hit 2 times")
			#hits_in_a_row = 0
		elif hits_in_a_row == 3:
			print("hit 3 times")
			#hits_in_a_row = 0
		elif hits_in_a_row <= 1:
			print("no combo")
		#hits_in_a_row = 0
		else:
			print("combo not valid yet")
		
		p_2_combo_timer.start()
	
	health_bar.set_health(p_1_current_health)
	await get_tree().create_timer(0.01).timeout
	life_check()

func life_check():
	if (p_1_current_health <= 0):
		lives_lost += 1
		stocks.get_child(0).queue_free()
		#reset round
		p_1_current_health = 100
		health_bar.set_health(100)

		if(lives_lost == 2):
			print("lost 3 lives")
			lose()

func lose():
	await get_tree().create_timer(1.5).timeout
	get_tree().paused = true
	text_animation_player.play("player_2_wins")
	await get_tree().create_timer(4).timeout
	get_tree().paused = false
	#freeze player inputs
	get_tree().change_scene_to_file("res://scenes/Ruixian/Character_Selection_Scene.tscn")

func anim_done(name: String):
	if name == "A1":
		attacking = false
	if name == "B1":
		attacking = false
	if name == "S1":
		attacking = false
		can_special1 = false
		$player1_LOADEDANIMS/Sprite2D/FrameDataSpecial1.damage = 0
	if name == "S2":
		attacking = false
		can_special2 = false
		$player1_LOADEDANIMS/Sprite2D/FrameDataSpecial2.damage = 0
	if name == "S3":
		attacking = false
		can_special3 = false
		$player1_LOADEDANIMS/Sprite2D/FrameDataSpecial3.damage = 0
	elif name == "jump":
		jumping = false

func _on_p_2_combo_timer_timeout() -> void:
	if hits_in_a_row == 2:
		sticker_manager.add_sticker_p_2("two")
		print("sticker change to 2")
			#hits_in_a_row = 0
	elif hits_in_a_row == 3:
		sticker_manager.add_sticker_p_2("three")
		print("sticker chnage to 3")
			#hits_in_a_row = 0
	elif hits_in_a_row == 4:
		sticker_manager.add_sticker_p_2("four")
	elif hits_in_a_row == 5:
		sticker_manager.add_sticker_p_2("five")
	
	hits_in_a_row = 0
	pass # Replace with function body.
