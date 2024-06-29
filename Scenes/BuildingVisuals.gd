extends Node3D

var burnPercentage := 0.25

@onready var lufkaMaterial = get_node("Lufka/lufka/Circle").get_surface_override_material(0)
var buildingsAmount



func cracklingPercentage(totalPercentage):
	return (totalPercentage - 0.7) * 3.33

# Not exactly the best way but it's the simplest and most obvious, also it works anyways
var modelVisibilities = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
func _ready():
	# Set the array containing the visibility status for each of the smoking apparatus to make the
	# size of the array match the size of the children list.
	# Then set the models to the save file
	# Acutally don't do it at all lmao
		#for child in children:
		#	modelVisibilities.append(false)
	refreshModelVisibilities()

func setOpalanie(amount):
	lufkaMaterial.set_shader_parameter("opalCoefficient", amount)


@onready var children = get_children()

# The building list is assumed to have exactly the same amount of children as there are elements in the
# model visibilities array
# Actually it isnt why tf did i write it here what the fuck

func setModelVisibility(index):
	modelVisibilities[index] = true
	refreshModelVisibilities()
func refreshModelVisibilities():
	var total = 0
	for i in range(0,modelVisibilities.size()):
		if i < children.size():
			children[i].visible = modelVisibilities[i]
			total = total + 1
	setPositions(total)

# Array containing positions of building based on the amount of buildings bought
var dist = 16
@export var rotationSpeed : float = 0.6
func setPositions(amount):
	if amount > children.size():
		return
	for i in range(0,amount):
		var angle = 0
		if i > 0:
			angle = PI/3*i
		var pos = Vector3(sin(angle),0,cos(angle)) * dist
		children[i].position = pos

func _process(delta):
	for i in range(children.size()):
		var cracklingPct = cracklingPercentage(burnPercentage)
		# smokeSpawnerTimer.wait_time = lerp(0.03,0.5,1 - burnPercentage)
		var smokeSpawner = children[i].get_node("Smoke Spawner")
		# smokeSpawner.voxelSize = 2 * burnPercentage
		# smokeSpawner.voxelDensity = 2 * burnPercentage
		# emit_signal("burning", delta)
		var fireLight = smokeSpawner.get_child(1)
		fireLight.light_energy = lerp(0.0, 8.0, burnPercentage - 0.25)
	# Rotate the building models
	
	rotate(Vector3(0,1,0), delta * rotationSpeed)
	
		
