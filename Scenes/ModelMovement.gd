extends Node3D

@onready var z = global_transform.origin.z
@export var anim_player : AnimationPlayer
@onready var smoke_spawner_position : Vector3 = get_node("BurnParticles").position
@onready var topek_insert_particles : GPUParticles3D = get_node("TopekInsert")

var time = 0
func _process(delta):
	time += delta
	position = Vector3(position.x,sin(time * 3) * 1.5,position.z)

func topek_insert_play():
	topek_insert_particles.emitting = true
