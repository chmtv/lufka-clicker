extends Sprite2D

@export var rot_vel = 0.0

func _process(delta):
	rotate(rot_vel*delta)
	# vvv Very cool effect that ill use in some random place like stats maybe idk
	#if (self.rotation_degrees > -45) or (self.rotation_degrees < 45):
	#	skew = -self.rotation_degrees * .01
	
