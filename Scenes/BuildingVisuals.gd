extends Node3D

var burnPercentage := 0.25
var buildingLevels = [0,0,0,0,0,0,0,0,0,0,0]

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
	topek_pause_timer.timeout.connect(func ():
		topek_particles.speed_scale = 1
		rotPaused = false
		
	)
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
var total = 0
func refreshModelVisibilities():
	total = 0
	for i in range(0,modelVisibilities.size()):
		if i < children.size():
			children[i].visible = modelVisibilities[i]
			if children[i].visible:
				total = total + 1
	setPositions(total)
	refresh_music_beat()

# Array containing positions of building based on the amount of buildings bought
var dist = 16
var rotationSpeed : float = 0.8
func setPositions(amount):
	if amount > children.size():
		return
	for i in range(1,amount):
		var angle = 0
		if i > 1:
			# PI/3 - 6 tools
			# PI/6 - more tools idk
			# PI/1.5 - 3 tools
			angle = PI/(amount/2.)*i
		var pos = Vector3(sin(angle),0,cos(angle)) * dist
		children[i].position = pos

@export var musicPlayer : AudioStreamPlayer
# 0, .2, .4, .6,  .8, 1., 1.2, 1.4,  1.6, 1.8, 2., 2.2,  2.4, 2.6, 2.8,
# minor for intro before the rotation was added in
# ZJEBNAE MNIEJ WIECEJ:
# 13-15
# 34
var minor_beats : Array[float] = [0.5,1.5, 2.5, 3.5 ,5.5, 6.5, 8.5, 9.5, 11.5, 12.5,   13, 14,15,17, 18,      20., 21., 23., 24., 26., 27., 29., 30., 31.5, 32.5, 34.5, 35.2, 35.7, 37.5,  38.5,40.5, 41.5, 43.5, 44.5, 46.5, 47.5, 49., 50., 52., 53., 55., 56., 58., 59., 61.,  62., 62.4, 62.8, 63.2, 63.6, 63.8, 64,  65., 65.8,  66.2, 66.4, 66.6, 66.8, 67., 68., 68.2, 
69., 70., 70.4, 70.6, 70.8, 71.2, 71.8, 72.4, 72.6, 72.8, 73.8, 75.8, 76.8, 78.8,79.8, 81.8, 82.3, 82.5, # mniej wiecej w tym momencie timingi niedojebane, chyba na 72???? idk
84.5,85.5, 87.5,88.5, 90.5, 91.5, 93.,94.5
]
var major_beats : Array[float] = [5, 8, 11,   14, 16.5, 19.5, 22.5, 25.5, 28.5, 31.5, 34.5, 39.5, 42.5, 45.5, 51.5, 54.5, 57.5, 60.5, 
	75, 78, 81
]
var rotation_beats = [[0, 4, 12, 22], [14.5, 15, 12, 8], [48, 49.5, 12, 8], [84, 85, 15, 8], [95., 96.8, 12, 8]]
var topek_pause_beats = [62.4, 62.8, 63.2, 63.6, 64., 64.2, 64.4,     66.3, 66.7, 66.9, 67.1, 67.3,  68.2, 68.4]
var next_minor_beat = 0
var next_major_beat = 0
var next_rotation_beat = 0
var next_pause_beat = 0
var rotPaused = false
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
	# Music dance
	if next_minor_beat < minor_beats.size() and musicPlayer.get_playback_position() > minor_beats[next_minor_beat]:
		_on_music_beat_timeout()
		next_minor_beat += 1
	if next_major_beat < major_beats.size() and musicPlayer.get_playback_position() > major_beats[next_major_beat]:
		on_major_beat()
		next_major_beat += 1
	if next_rotation_beat < rotation_beats.size() and musicPlayer.get_playback_position() > rotation_beats[next_rotation_beat][0]:
		print("chuhcudhucdhuchudhcud")
		on_rotation_beat()
		next_rotation_beat += 1
	if next_pause_beat < topek_pause_beats.size() and musicPlayer.get_playback_position() > topek_pause_beats[next_pause_beat]:
		on_topek_pause_beat()
		next_pause_beat += 1
	if not rotPaused:
		rotate(Vector3(0,1,0), delta * rotationSpeed)
	
		

# Music beat

func refresh_music_beat():
	max_building_index = 1
	for child in children:
		if child.visible:
			max_building_index += 1
	max_building_index -= 2


# var burn_beat_cuttoff : float = 0.67
var burn_beat_cuttoff : float = 0.0
func play_music_beat_animation(node):
	if burnPercentage < burn_beat_cuttoff:
		return
	var tween = create_tween()
	var tween2 = create_tween()
	tween.tween_property(node, "position", Vector3(node.position.x,0.,node.position.z), 0.4).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(node, "position", Vector3(node.position.x, 8.0, node.position.z), 0.2).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(node, "position", Vector3(node.position.x,0.,node.position.z), 0.4).set_trans(Tween.TRANS_QUAD)
	tween2.tween_property(self, "scale", Vector3(1, 1, 1), 0.4).set_trans(Tween.TRANS_QUAD)
	tween2.tween_property(self, "scale", Vector3(1.08, 1.08, 1.08), 0.2).set_trans(Tween.TRANS_QUAD)
	tween2.tween_property(self, "scale", Vector3(1,1,1), 0.4).set_trans(Tween.TRANS_QUAD)

var next_building_index : int = 1


@onready var max_building_index : int = children.size()-1
func _on_music_beat_timeout():
	next_building_index += 1
	if next_building_index > max_building_index:
		next_building_index = 1
	var model_node = children[next_building_index]
	play_music_beat_animation(model_node)
@export var topek_particles : GPUParticles3D
# @onready var beat_tween = get_tree().create_tween()
@export var topek_attractor : GPUParticlesAttractor3D
@export var environment : Environment
func on_major_beat():
	# topek_particles.speed_scale = 3
	var beat_tween = get_tree().create_tween()
	var flash_tween = get_tree().create_tween()
	# explosion that doesnt fucking work properly
	# topek_attractor.radius = 15
	# topek_attractor.attenuation = 0
	# topek_attractor.strength = -5
	# get_tree().create_timer(0.5).timeout.connect(func ():
	# 	topek_attractor.strength = 20
	# 	topek_attractor.radius = 100
	# 	topek_attractor.attenuation = 1
	# 	)
	rotate_animation(4, 0.7)
	flash_tween.tween_property(environment, "background_energy_multiplier", 1.15, 0.2).set_trans(Tween.TRANS_QUAD )
	flash_tween.tween_property(environment, "background_energy_multiplier", 1, 0.7).set_trans(Tween.TRANS_QUAD )
	# speedup that kinda looks like shit
	beat_tween.tween_property(topek_particles, "speed_scale", 3, 0.1).set_trans(Tween.TRANS_QUAD )
	beat_tween.tween_property(topek_particles, "speed_scale", 1, 0.8).set_trans(Tween.TRANS_QUAD)


func set_dist(_dist : float):
	dist = _dist
	setPositions(total)
func on_rotation_beat():
	var finalval = rotation_beats[next_rotation_beat][2]
	var duration = rotation_beats[next_rotation_beat][1] - rotation_beats[next_rotation_beat][0] + 0.1
	print(finalval, duration)
	var finaldist = rotation_beats[next_rotation_beat][3]
	rotate_animation(finalval, duration)
	var kurwa_tween = get_tree().create_tween()
	kurwa_tween.tween_method(set_dist, 16, finaldist, duration * (3./5.)).set_trans(Tween.TRANS_QUART)
	kurwa_tween.tween_method(set_dist, finaldist, 16, duration * (2./5.)).set_trans(Tween.TRANS_QUART)
	#kurwa_tween.tween_property(self, "dist", 30, duration * (3./5.)) 
	#kurwa_tween.tween_property(self, "dist", 1, duration * (2./5.))
func rotate_animation(finalval, duration):
	var pierdolony_tween = get_tree().create_tween() # Ty kurwo jebana tylko kurwa sprobuj fpsy mi rozjebac
	pierdolony_tween.tween_property(self, "rotationSpeed", finalval, duration * (3./5.))
	pierdolony_tween.tween_property(self, "rotationSpeed", 0.8, duration *(2./5.))

# Lighter visuals
var next_lighter_target : int = 2 # Starts from 2 becuase the first node is the lighter and because of the subtraction
var lighter_swap_time : float = 2
@export var lighter_timer : Timer
@onready var lighter_node = children[0]
func _on_lighter_movement_timeout():
	lighter_swap_time = 1 + 4 * (1-burnPercentage)
	lighter_timer.wait_time = lighter_swap_time
	next_lighter_target += 1
	if next_lighter_target > max_building_index:
		next_lighter_target = 1
	

	var lighter_tween = create_tween()
	var next_target_node = children[next_lighter_target]
	var position_offset = children[next_lighter_target].smoke_spawner_position
	var final_target_pos = next_target_node.position + position_offset
	lighter_node.look_at(final_target_pos)
	lighter_tween.tween_property(lighter_node, "position", next_target_node.position + position_offset, lighter_swap_time/3.0).set_trans(Tween.TRANS_QUAD)

@export var topek_pause_timer : Timer
var rot_tp_direction : float = -1
func on_topek_pause_beat():
	if rot_tp_direction == 1:
		rot_tp_direction = -1
	else:
		rot_tp_direction = 1
	# PI/(total/2)
	rotate(Vector3(0,1,0), -(PI*2)/(total-1))
	# rotate(Vector3(0,1,0), -1 * 0.2 * rotationSpeed)
	if topek_particles.speed_scale > 0:
		topek_particles.speed_scale = 0
		rotPaused = true
	else:
		topek_particles.speed_scale = 7
		rotPaused = false

		topek_pause_timer.start()



func _on_topek_insert_timeout():
	var prob = 0.2
	for child in children:
		var diceResult = randf_range(0,1)
		if child.get_script() and diceResult <= prob: # bullshit way to check if ModelMovement.gd is there
			child.topek_insert_play()
