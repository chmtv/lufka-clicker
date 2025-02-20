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
	refresh_music_beat()

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
			if children[i].visible:
				total = total + 1
	setPositions(total)
	refresh_music_beat()

# Array containing positions of building based on the amount of buildings bought
var dist = 16
@export var rotationSpeed : float = 0.6
func setPositions(amount):
	if amount > children.size():
		return
	for i in range(0,amount):
		var angle = 0
		if i > 0:
			# PI/3 - 6 tools
			# PI/6 - more tools idk
			# PI/1.5 - 3 tools
			angle = PI/(amount/2)*i
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
	
		

# Music beat

func refresh_music_beat():
	max_building_index = 1
	for child in children:
		if child.visible:
			max_building_index += 1
	max_building_index -= 2

var burn_beat_cuttoff : float = 0.67
func play_music_beat_animation(node):
	if burnPercentage < burn_beat_cuttoff:
		return
	var tween = create_tween()
	tween.tween_property(node, "position", Vector3(node.position.x,0.,node.position.z), 0.4).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(node, "position", Vector3(node.position.x, burnPercentage * 8.0, node.position.z), 0.2).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(node, "position", Vector3(node.position.x,0.,node.position.z), 0.4).set_trans(Tween.TRANS_QUAD)

var next_building_index : int = 1
@onready var max_building_index : int = children.size()-1
func _on_music_beat_timeout():
	next_building_index += 1
	if next_building_index > max_building_index:
		next_building_index = 1
	var model_node = children[next_building_index]
	print(max_building_index)
	play_music_beat_animation(model_node)
