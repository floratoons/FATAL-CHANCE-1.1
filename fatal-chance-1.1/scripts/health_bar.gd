extends TextureProgressBar

@onready var timer = $Timer
@onready var damage_bar = $DamageBar

var health = 0 : set = set_health

func set_health(new_health):
	value = new_health

func init_health(_health):
	value = _health

#func _on_timer_timeout() -> void:
	#damage_bar.value = health
	#pass # Replace with function body.
