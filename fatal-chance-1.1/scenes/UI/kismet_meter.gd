extends Control

@onready var meter = $MeterTexture
var can_deplete = false
var is_depleting = false
var deplete_amt = 6.5
@onready var timer = $Timer
#@onready var timer_amt = $Timer.wait_time

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#whatever function that builds the meter would be handled in kismet's script?
	if meter.value >= 35 and meter.value < 65:
		can_deplete = true
		timer.wait_time = 5
	elif meter.value >= 65 and meter.value < 100:
		can_deplete = true
		timer.wait_time = 10
	elif meter.value == 100:
		can_deplete = true
		timer.wait_time = 15
	else:
		can_deplete = false
	pass
	
	#this function here is for the sake of testing - change or take out if input will be controlled through the player script
	if Input.is_action_just_pressed("C_p1"):
		meter_active()
			#if timer.wait_time > 0:
				#value -= deplete_amt
			#if value <= 0:
				#timer.stop()
				#print("depleted"
	
func meter_active():
	if can_deplete == true:
		
		#need to figure out how to make the meter deplete per second; possibly would need another timer but hopefully no. 
		#the math below has to happen every second while the timer is running
		#meter.value -= deplete_amt
		#or
		#var tween = get_tree().create_tween()
		#tween.tween_property(self, meter.value, 0, timer.wait_time)
		#the tween should techincally be a better solution but it is not working currently;
		print(timer.wait_time)
	pass

func _on_timer_timeout() -> void:
	meter.value = 0
	timer.stop()
	print("timer ended, meter depleted")
	pass # Replace with function body.
