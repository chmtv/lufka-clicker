extends Button

# @export var cooldown : float = 60.0
@export var cooldown_progress : TextureProgressBar
@export var cooldown_timer : Timer
func refresh_cooldown_status():

	cooldown_progress.value = 1 - (cooldown_timer.time_left / cooldown_timer.wait_time)

func _on_pressed():
	disabled = true
	cooldown_progress.visible = true
	# modulate = Color(17.,3.,0.,1.0)
	# modulate = Color(0.06,0.01,0.,1.0)
	cooldown_timer.start()

func _on_cooldown_timeout():
	disabled = false
	cooldown_progress.visible = false
	modulate = Color(1.,1.,1.,1.)
	cooldown_timer.stop()
