extends Button

signal burning(delta)
signal burnPress;

var burnPercentage = 0.0
var particles
var fireLight
var burnSoundNode
@onready var smokeSpawner = get_node("Palenie/Smoke Spawner")
@onready var pressAnimation = get_node("Button Press Anim")


func _ready():
	particles = get_node("Palenie/BurnParticles")
	fireLight = get_node("Palenie/Smoke Spawner/FireLight")
	burnSoundNode = get_node("Burn Sound")
	button_down.connect(handleButtonDown)
	button_up.connect(handleButtonUp)

var isPressed = false
func handleButtonDown():
	isPressed = true
func handleButtonUp():
	isPressed = false
func _on_pressed():
	emit_signal("burnPress")
	pressAnimation.play("burnPress")

func cracklingPercentage(totalPercentage):
	return (totalPercentage - 0.7) * 3.33

func _process(delta):
	var cracklingPct = cracklingPercentage(burnPercentage)
	# burnSoundNode.pitch_scale = lerp(1.0, 3.0, cracklingPct)
	burnSoundNode.volume_db = lerp(-11, -23, 1 - cracklingPct)
	if burnPercentage > 0.7 and !burnSoundNode.playing:
		burnSoundNode.playing = true


