extends Node

@onready var text = $TimerText
@onready var timer = $RoundTimer

var time = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	assign_time()

# different timer for fighting vs training level
func assign_time():
	if (owner.name == "TrainingLevel"):
		time = 100000
	else:
		pass
	#print("Scene: " + str(owner.name) + "Time: " + str(time))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if time > 0:
		time -= delta
		text.text = str(snapped(ceil(time),0))
	else:
		pass

func reset_timer():
	assign_time()
	pass
