extends Panel

# Photosynthesis, the meeting point of the other currencies
var photosynthesis := 0.5
@export var phsMult : float = 1.0
# A plant takes 45min to grow fully, 
var phsPerPhase = 500
var phsPerSecTotal = 3000.6
@export var PlantVisuals : Control

# Light
var light := 0.0
var maxLight := 1000.0
var minLight := 0.0
var isLighting := false
var lightPerSec := 1.25
@export var lightProgressBar : TextureProgressBar
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
	PlantVisuals.isWatered = false
	waterButton.disabled = false

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
var deltaPhs = 510
func addPhotosynthesis(phs):
	var phsToAdd = phs * phsMult
	photosynthesis += phsToAdd
	deltaPhs += phsToAdd
	if photosynthesis > 2000:
		photosynthesis = phs
	if deltaPhs > 125:
		PlantVisuals.refreshPlant(photosynthesis)
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
	text += "Fotosynteza: x" + str(getPhotosynthesisCoeffTotal()*100) + "%"
	text += "\n"
	text += "Fotosynteza: " + str(getPhotosynthesisForPhase()) + "/500"
	text += "\n"
	text += "[center]"
	photosynthesis_label.text = text
	phs_phase_label.text = '[wave][center]'+getPhaseName()+'[/center][/wave]'
func _process(delta):
	# Light decay and increasing
	if isLighting:
		light += delta * lightPerSec
	else:
		light = max(light - delta * lightPerSec * 0.125, 0.0)
	lightProgressBar.value = light
	# Photosynthesis calculation and display
	var phs = delta * phsPerSecTotal * getPhotosynthesisCoeffTotal()
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
