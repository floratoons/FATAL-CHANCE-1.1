extends Node

@onready var text = $TimerText
@onready var timer = $RoundTimer

var time = 100
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if time > 0:
		time -= delta
		text.text = str(snapped(ceil(time),0))
	else:
		pass

func reset_timer():
	time = 100
	pass
