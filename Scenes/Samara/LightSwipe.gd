extends Panel

func setLightSwipeTime(time):
	# Set the time uniform in the shader
	material.set_shader_parameter("time", time)
func playLightSwipe():
	get_tree().create_tween().tween_method(setLightSwipeTime,-0.3,1.2, 0.45).set_trans(Tween.TRANS_LINEAR)
