extends Panel

# mult naming scheme:
# multipliedScalingMultCurrency
var leafAddMultThcLevel = 0
var leafMultiplicativeMultLeafLevel = 0
var leafAddMultLeafLevel = 0
var leafAddMultLeaf = 1
var leafMultiplicativeMultLeaf = 1
var leafAddMultThc = 1

func set_leaf_add_mult_thc_level(level):
	leafAddMultThcLevel = level
	leafAddMultThc = 1 + level*0.5
	show_mult()
func set_leaf_multiplicative_mult_leaf_level(level):
	leafMultiplicativeMultLeafLevel = level
	leafMultiplicativeMultLeaf = pow(1.2, level)
	show_mult()
func set_leaf_add_mult_leaf_level(level):
	leafAddMultLeafLevel = level
	leafAddMultLeaf = 1 + leafAddMultLeafLevel * 0.5
	show_mult()

# Photosynthesis, the meeting point of the other currencies
var photosynthesis := 0.5
var phsMult : float = 1.0
# A plant takes 45min to grow fully, 
var phsPerPhase = 500
#var phsPerSecTotal = 3000.6
@export var PlantVisuals : Control
@export var mainManager : Node
# Light
var light := 0.0
var maxLight := 1000.0
var minLight := 0.0
var isLighting := false
var lightPerSec := 4
@export var lightProgressBar : TextureProgressBar
var lightGodMult : float = 1
func _on_light_button_down():
	isLighting = true
func _on_light_button_up():
	isLighting = false


# Watering
@onready var waterTimer := get_tree().create_timer(180)
@export var waterButton : Button 
var isWatered := true
func makePlantThirsty():
	isWatered = false
	PlantVisuals.makePlantThirsty()
	# waterButton.disabled = false
func rehydratePlant():
	isWatered = true
	PlantVisuals.rehydratePlant()

# Airflow
var airflowLevel = 0
var maxAirflow = 5
@export var airflowIncreaseTimer : Timer
var canIncreaseAirflow = true
@export var airflowDecayTimer : Timer
@export var airflowProgress : TextureProgressBar
@export var airflowButton : Button
@onready var airflowDecayTime = airflowDecayTimer.wait_time
func decreaseAirflow():
	airflowLevel = max(airflowLevel-1, 0)
	airflowProgress.value = airflowLevel
func increaseAirflow():
	airflowLevel = min(airflowLevel+1, maxAirflow)
	airflowProgress.value = airflowLevel
	airflowDecayTimer.start(airflowDecayTime)

# TODO Later: Disease

# Nutrients
var nutrients : int = 0
@onready var nextNutrientTimer = get_tree().create_timer(30)


func getLightCoeff():
	return 2/(1+exp(0.01*abs(light-500)))
func getWateringCoeff():
	return 1.0 if isWatered else 0.25

@export var leavesLabel : RichTextLabel
@export var collectButton : Resource
func addLeaves(_leaves):
	leaves += _leaves
	leavesLabel.text = "Liście: " + str(leaves) + ""
var isCollectable := false
func makeCollectable():
	isCollectable = true
	var buttonInstance = collectButton.instantiate()
	add_child(buttonInstance)
	buttonInstance.connect("pressed", collect)
var leaves = 0
var leavesPerCollect = 4
func collect():
	isCollectable = false
	photosynthesis = 0
	var totalMult = get_total_mult()
	addLeaves(leavesPerCollect * totalMult)
	# No boilerplate as I once again forgot how to do it with nodes lmao and im not sure whether it was the usual method of a simple if
	get_node("CollectButton").queue_free()
	mainManager.set_leaves()

func set_leaves(_leaves):
	leaves = _leaves
	addLeaves(0)
func get_total_mult():
	return leafMultiplicativeMultLeaf * leafAddMultLeaf * leafAddMultThc
@export var multLabel = RichTextLabel
func show_mult():
	multLabel.text = "[wave]Po zebraniu: +"+str(leavesPerCollect)+"Liście ×" + str(snapped(get_total_mult(),0.01)) + "[/wave]"
var deltaPhs = 510
func get_phs():
	return photosynthesis
func set_phs(_phs):
	photosynthesis = _phs
	addPhotosynthesis(0)
func addPhotosynthesis(phs):
	if not isCollectable:
		var phsToAdd = phs * phsMult
		photosynthesis += phsToAdd
		deltaPhs += phsToAdd
		if photosynthesis > 2000:
			makeCollectable()
		if deltaPhs > 20:
			PlantVisuals.refreshPlant(photosynthesis)
		if deltaPhs > 125:
			PlantVisuals.regeneratePlant(photosynthesis)
			deltaPhs = 0
func getPhaseName():
	var name := ""
	if photosynthesis < 500:
		name = "Kiełkowanie"
	elif photosynthesis < 1000:
		name = "Wegetacja"
	elif photosynthesis < 1500:
		name = "Kwitnienie"
	elif photosynthesis < 2000:
		name = "Zbieranie"
	return name
func getPhasePhsProgress(phs = photosynthesis):
	return int(snapped(fmod(min(phs, 2000) / 500, 4), 1))
@export var photosynthesis_label : RichTextLabel
@export var phs_phase_label : RichTextLabel
@export var phs_progress_bar : TextureProgressBar
func getPhotosynthesisCoeffTotal():
	return snapped( getLightCoeff() * (airflowLevel * 0.2) * getWateringCoeff() , 0.001)
func getPhotosynthesis():
	return photosynthesis
func getPhotosynthesisForPhase():
	var phase_phs = snapped(fmod(photosynthesis, 500.0), 1)
	phs_progress_bar.value = phase_phs
	return phase_phs
func updatePhsLabels():
	var text = "[center]"
	# text += "Fotosynteza: x" + str(getPhotosynthesisCoeffTotal()*100) + "%"
	text += "Fotosynteza: " + str(getPhotosynthesisForPhase()) + "/500"
	text += "\n"
	text += "x" + str(getPhotosynthesisCoeffTotal()*100) + "%"
	text += "\n"
	text += "[center]"
	photosynthesis_label.text = text
	phs_phase_label.text = '[wave][center]'+getPhaseName()+'[/center][/wave]'
func _process(delta):
	# Light decay and increasing
	if isLighting:
		light += delta * lightPerSec * lightGodMult
	else:
		light = max(light - delta * lightPerSec * 0.125 * lightGodMult, 0.0)
	lightProgressBar.value = light
	PlantVisuals.setLight(light)
	# Photosynthesis calculation and display
	var phs = 3.33 * delta * getPhotosynthesisCoeffTotal()
	addPhotosynthesis(phs)
	
	updatePhsLabels()

func _ready():
	airflowDecayTimer.connect("timeout", func():
		decreaseAirflow()
		)
	airflowIncreaseTimer.connect("timeout", func():
		canIncreaseAirflow = true
		airflowButton.disabled = false
		)
	airflowDecayTimer.start()
	airflowIncreaseTimer.start()


func _on_airflow_button_pressed():
	if canIncreaseAirflow:
		increaseAirflow()
		airflowButton.disabled = true


func _on_water_need_timeout():
	makePlantThirsty()


func _on_water_button_pressed():
	rehydratePlant()
