extends Button

signal burning(delta)
signal isBurning
signal isNotBurning
signal burnPress;

var burnPercentage = 0.0
var particles
var fireLight
var burnSoundNode
@onready var smokeSpawner = get_node("Palenie/Smoke Spawner")
@onready var pressAnimation = get_node("Button Press Anim")
@onready var progressBar = get_node("Burn Progress")

func _ready():
	particles = get_node("Palenie/BurnParticles")
	fireLight = get_node("Palenie/Smoke Spawner/FireLight")
	burnSoundNode = get_node("Burn Sound")
	button_down.connect(handleButtonDown)
	button_up.connect(handleButtonUp)

var isPressed = false
func handleButtonDown():
	emit_signal("isBurning")
	isPressed = true
func handleButtonUp():
	emit_signal("isNotBurning")
	isPressed = false
func _on_pressed():
	# emit_signal("burnPress")
	pressAnimation.play("burnPress")

func cracklingPercentage(totalPercentage):
	return (totalPercentage - 0.7) * 3.33

func _process(delta):
	var cracklingPct = cracklingPercentage(burnPercentage)
	# burnSoundNode.pitch_scale = lerp(1.0, 3.0, cracklingPct)
	burnSoundNode.volume_db = lerp(-15, -30, 1 - cracklingPct)#  if isBurning else 0
	if isPressed:
		var mousePos = get_global_mouse_position()
		var burnParticles = preload("res://Scenes/Particles/burnParticles.tscn").instantiate()
		burnParticles.position = mousePos
		get_tree().root.add_child(burnParticles)
	
	if !burnSoundNode.playing: # Old, based on burning %:        burnPercentage > 0.7 and !burnSoundNode.playing:
		burnSoundNode.playing = true
	#elif !isPressed:
	#	burnSoundNode.playing = false


