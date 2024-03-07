extends Node3D

@onready var z = global_transform.origin.z

var time = 0
func _process(delta):
	time += delta
	global_transform.origin = Vector3(0,sin(time * 3) * 1.5,z)
