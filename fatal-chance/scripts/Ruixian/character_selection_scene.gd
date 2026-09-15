extends Node2D

# Get references to all nodes in the scene
@onready var p1_label = $P1Label
@onready var p2_label = $P2Label
@onready var card1 = $CharacterGrid/CharacterCard1
@onready var card2 = $CharacterGrid/CharacterCard2

# Indicator that follows the mouse when hovering
@onready var indicator = $PlayerIndicator

# Indicator that stays locked on P1's chosen character
@onready var locked_indicator = $LockedIndicator1

# Indicator that stays locked on P2's chosen character
@onready var locked_indicator2 = $LockedIndicator2

@onready var border1 = $CharacterGrid/CharacterCard1/Border
@onready var border2 = $CharacterGrid/CharacterCard2/Border

#Animation of the Text
@onready var text_slide_anim = $TextSlideInAnimationPlayer

#characters to load
var anathema = preload("res://scenes/anathema_anims.tscn")
var talisman = preload("res://scenes/talisman_anims.tscn")
var player_not_selected = false

# Whose turn it is: 1=P1, 2=P2, 0=both done
var current_turn : int = 1

# The character name chosen by each player
var p1_choice : String = ""
var p2_choice : String = ""

# Timer for the hover indicator bounce animation
var bounce_time : float = 0.0

# Whether the mouse is currently hovering over a card
var is_hovering : bool = false

# Base Y position for the hover indicator (bounce animates around this point)
var base_y : float = 0.0

# Base Y position and bounce timer for P1's locked indicator
var locked_base_y : float = 0.0
var locked_bounce_time : float = 0.0

# Base Y position and bounce timer for P2's locked indicator
var locked_base_y2 : float = 0.0
var locked_bounce_time2 : float = 0.0

func _ready():
	# Initialize status labels
	p1_label.text = "P1: Selecting..."
	p2_label.text = "P2: Waiting..."
	
	# Hide all indicators and set font size
	indicator.visible = false
	indicator.add_theme_font_size_override("font_size", 28)
	
	locked_indicator.visible = false
	locked_indicator.add_theme_font_size_override("font_size", 28)
	
	locked_indicator2.visible = false
	locked_indicator2.add_theme_font_size_override("font_size", 28)
	
	# Hide all borders
	border1.visible = false
	border2.visible = false
	
	# Connect hover and click signals for both cards
	card1.mouse_entered.connect(_on_card1_hover_enter)
	card1.mouse_exited.connect(_on_card_hover_exit)
	card2.mouse_entered.connect(_on_card2_hover_enter)
	card2.mouse_exited.connect(_on_card_hover_exit)
	card1.pressed.connect(_on_card1_pressed)
	card2.pressed.connect(_on_card2_pressed)
	
	#Animation
	text_slide_anim.play("Slide In")
	await text_slide_anim.animation_finished
	text_slide_anim.play("pop")
	


func _process(delta):
	# Update hover indicator bounce every frame
	if is_hovering:
		bounce_time += delta * 4.0
		# sin function makes Y position loop up and down 8px around base_y
		indicator.position.y = base_y + sin(bounce_time) * 8.0
	# Update P1 locked indicator bounce every frame
	if locked_indicator.visible:
		locked_bounce_time += delta * 4.0
		locked_indicator.position.y = locked_base_y + sin(locked_bounce_time) * 8.0
	# Update P2 locked indicator bounce every frame
	if locked_indicator2.visible:
		locked_bounce_time2 += delta * 4.0
		locked_indicator2.position.y = locked_base_y2 + sin(locked_bounce_time2) * 8.0

# Returns the position just above the center of a card, for placing indicators
func _get_card_top_center(card: TextureButton) -> Vector2:
	var pos = card.global_position
	var size = card.size
	# X is centered on the card, Y is 65px above the card
	return Vector2(pos.x + size.x / 2 - 20, pos.y - 65)

# When mouse enters card1
func _on_card1_hover_enter():
	# If P1 already locked card1, P2 hovering does nothing
	if current_turn == 2 and p1_choice == "Anathema":
		return
	is_hovering = true
	bounce_time = 0.0
	indicator.visible = true
	indicator.position = _get_card_top_center(card1)
	base_y = indicator.position.y
	# Show indicator and border in the current player's color
	if current_turn == 1:
		indicator.text = "P1"
		indicator.add_theme_color_override("font_color", Color(0.996, 0.0, 0.941))
		_set_border(border1, Color(0.996, 0.0, 0.941))
		#adds the char sprite to the side
		var anathema_instance = anathema.instantiate()
		$P1Marker.add_child(anathema_instance)
		$P1Marker/Sprite2D/AnimationPlayer.play("idle")
		#starts character splash flicker
		$SplashAnimationPlayer.play("anathema1_flicker")
	elif current_turn == 2:
		indicator.text = "P2"
		indicator.add_theme_color_override("font_color", Color(1, 0.9, 0.0))
		_set_border(border1, Color(1, 0.9, 0.0))
		#adds the char sprite to the side
		var anathema_instance = anathema.instantiate()
		$P2Marker.add_child(anathema_instance)
		anathema_instance.scale.x = -1
		$P2Marker/Sprite2D/AnimationPlayer.play("idle")
		$SplashAnimationPlayer.play("anathema2_flicker")

# When mouse enters card2
func _on_card2_hover_enter():
	# If P1 already locked card2, P2 hovering does nothing
	if current_turn == 2 and p1_choice == "Talisman":
		return
	is_hovering = true
	bounce_time = 0.0
	indicator.visible = true
	indicator.position = _get_card_top_center(card2)
	base_y = indicator.position.y
	# Show indicator and border in the current player's color
	if current_turn == 1:
		indicator.text = "P1"
		indicator.add_theme_color_override("font_color", Color(0.996, 0.0, 0.941))
		_set_border(border2, Color(0.996, 0.0, 0.941))
		#add char sprite to side
		var talisman_instance = talisman.instantiate()
		$P1Marker.add_child(talisman_instance)
		$P1Marker/Sprite2D/AnimationPlayer.play("idle")
		$SplashAnimationPlayer.play("talisman1_flicker")
	elif current_turn == 2:
		indicator.text = "P2"
		indicator.add_theme_color_override("font_color", Color(1, 0.9, 0.0))
		_set_border(border2, Color(1, 0.9, 0.0))
		#add char sprite
		var talisman_instance = talisman.instantiate()
		$P2Marker.add_child(talisman_instance)
		talisman_instance.scale.x = -1
		$P2Marker/Sprite2D/AnimationPlayer.play("idle")
		$SplashAnimationPlayer.play("talisman2_flicker")

# When mouse exits any card
func _on_card_hover_exit():
	is_hovering = false
	indicator.visible = false
	# Only clear borders that are not locked
	if p1_choice != "Anathema" and p2_choice != "Anathema":
		border1.visible = false
	if p1_choice != "Talisman" and p2_choice != "Talisman":
		border2.visible = false
	#sets up sprite deletion when not hovering on a card
	if current_turn == 1:
		if p1_choice != "Anathema" and p2_choice != "Anathema":
			$P1Marker/Sprite2D.queue_free()
			$SplashAnimationPlayer.play("p1_default")
		if p1_choice != "Talisman" and p2_choice != "Talisman":
			$P1Marker/Sprite2D.queue_free()
			$SplashAnimationPlayer.play("p1_default")
	if current_turn == 2 and $P2Marker.get_child_count() == 1:
		if p1_choice != "Anathema" and p2_choice != "Anathema":
			$P2Marker/Sprite2D.queue_free()
			$SplashAnimationPlayer.play("p2_default")
		if p1_choice != "Talisman" and p2_choice != "Talisman":
			$P2Marker/Sprite2D.queue_free()
			$SplashAnimationPlayer.play("p2_default")

# Creates a StyleBox with a colored border and transparent background, applies it to a Panel
func _set_border(border: Panel, color: Color):
	border.visible = true
	var style = StyleBoxFlat.new()
	# Transparent background
	style.bg_color = Color(0, 0, 0, 0)
	style.border_color = color
	# 4px border on all sides
	style.border_width_left = 4
	style.border_width_right = 4
	style.border_width_top = 4
	style.border_width_bottom = 4
	border.add_theme_stylebox_override("panel", style)

# Card1 clicked, select character 1
func _on_card1_pressed():
	$ClickSound.play()
	$Anathema.play()
	_select_character("Anathema")

# Card2 clicked, select character 2
func _on_card2_pressed():
	$ClickSound.play()
	$Talisman.play()
	_select_character("Talisman")

func _select_character(character_name: String):
	if current_turn == 1:
		# P1 selects a character, record choice, update labels, switch turn to P2
		p1_choice = character_name
		p1_label.text = "P1: ✓ " + character_name
		p2_label.text = "P2: Selecting..."
		current_turn = 2
		#adds the char sprite to the side
		if character_name == "Anathema":
			$P1Marker/Sprite2D.queue_free()
			await get_tree().create_timer(0.2).timeout
			var anathema_instance = anathema.instantiate()
			$P1Marker.add_child(anathema_instance)
			$P1Marker/Sprite2D/AnimationPlayer.play("idle")
			$SplashAnimationPlayer.play("anathema1_select")
		if character_name == "Talisman":
			$P1Marker/Sprite2D.queue_free()
			await get_tree().create_timer(0.2).timeout
			var talisman_instance = talisman.instantiate()
			$P1Marker.add_child(talisman_instance)
			$P1Marker/Sprite2D/AnimationPlayer.play("idle")
			$SplashAnimationPlayer.play("talisman1_select")
		# Find the card and border that P1 selected
		var selected_card = card1 if character_name == "Anathema" else card2
		var selected_border = border1 if character_name == "Anathema" else border2
		# Lock red border on selected card
		_set_border(selected_border, Color(0.996, 0.0, 0.941))
		# Lock P1 indicator above selected card
		locked_indicator.text = "P1"
		locked_indicator.add_theme_color_override("font_color", Color(0.996, 0.0, 0.941))
		locked_indicator.position = _get_card_top_center(selected_card)
		locked_base_y = locked_indicator.position.y
		locked_indicator.visible = true
		# Hide the hover indicator
		is_hovering = false
		indicator.visible = false
	elif current_turn == 2:
		# P2 cannot pick the same character as P1
		if character_name == p1_choice:
			p2_label.text = "P2: Please select a different character!"
			return
		# P2 selects a character, record choice, update labels
		p2_choice = character_name
		p2_label.text = "P2: ✓ " + character_name
		current_turn = 0
		#adds the char sprite to the side & splash select
		if character_name == "Anathema":
			$P2Marker/Sprite2D.queue_free()
			await get_tree().create_timer(0.2).timeout
			var anathema_instance = anathema.instantiate()
			$P2Marker.add_child(anathema_instance)
			anathema_instance.scale.x = -1
			$P2Marker/Sprite2D/AnimationPlayer.play("idle")
			$SplashAnimationPlayer.play("anathema2_select")
		if character_name == "Talisman":
			$P2Marker/Sprite2D.queue_free()
			await get_tree().create_timer(0.2).timeout
			var talisman_instance = talisman.instantiate()
			$P2Marker.add_child(talisman_instance)
			talisman_instance.scale.x = -1
			$P2Marker/Sprite2D/AnimationPlayer.play("idle")
			$SplashAnimationPlayer.play("talisman2_select")
		# Find the card and border that P2 selected
		var selected_card = card1 if character_name == "Anathema" else card2
		var selected_border = border1 if character_name == "Anathema" else border2
		# Lock yellow border on selected card
		_set_border(selected_border, Color(1, 0.9, 0.0))
		# Lock P2 indicator above selected card
		locked_indicator2.text = "P2"
		locked_indicator2.add_theme_color_override("font_color", Color(1, 0.9, 0.0))
		locked_indicator2.position = _get_card_top_center(selected_card)
		locked_base_y2 = locked_indicator2.position.y
		locked_indicator2.visible = true
		# Hide the hover indicator
		is_hovering = false
		indicator.visible = false
		# Wait 1.8 seconds then go to map selection
		await get_tree().create_timer(1.8).timeout
		_go_to_map_selection()

# Save both players' choices to GlobalData and switch to the map selection scene
func _go_to_map_selection():
	GlobalData.p1_character = p1_choice
	GlobalData.p2_character = p2_choice
	await SceneTransition.fade_in()
	get_tree().change_scene_to_file("res://scenes/Ruixian/Map_Selection_Scene.tscn")
