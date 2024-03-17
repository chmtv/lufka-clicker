extends Node3D

@onready var z = global_transform.origin.z


var time = 0
func _process(delta):
	time += delta
	position = Vector3(position.x,sin(time * 3) * 1.5,position.z)
