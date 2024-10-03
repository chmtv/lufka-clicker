extends Sprite2D

@export var rot_vel = 0.0

func _physics_process(delta):
	rotate(rot_vel*delta)
