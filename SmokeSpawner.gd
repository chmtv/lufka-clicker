extends Node3D

var isSpawning = true
var voxelSize = 1.0
var voxelDensity = 3.0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var posRandomness = 1.2

var rng = RandomNumberGenerator.new()
@onready var smokeVoxel = load("res://Scenes/Smoke Voxel.tscn")
func _on_timer_timeout():
	if isSpawning:
		var voxelInstance = smokeVoxel.instantiate()
		add_child(voxelInstance)
		voxelInstance.size = Vector3(voxelSize, voxelSize + 2, voxelSize)
		voxelInstance.material.density = voxelDensity
		voxelInstance.position = Vector3(
			rng.randf_range(-posRandomness, posRandomness),
			rng.randf_range(-posRandomness, posRandomness),
			0
		)


func _on_burn_button_burning(delta):
	isSpawning = true
