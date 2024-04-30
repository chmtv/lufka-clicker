extends Panel

# Photosynthesis, the meeting point of the other currencies
var photosynthesis := 0.5
# A plant takes 45min to grow fully, 
var phsPerPhase = 500
var phsPerSecTotal = 0.6


# Light
var light := 0.0
var maxLight := 1000.0
var minLight := 0.0
var isLighting := false
var lightPerSec := 100.25
@export var lightProgressBar : TextureProgressBar
func _on_light_button_down():
	isLighting = true
func _on_light_button_up():
	isLighting = false



# Watering
@onready var waterTimer := get_tree().create_timer(180)
var isWatered := true
func makePlantThirsty():
	pass

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
func addPhotosynthesis(phs):
	photosynthesis += phs
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

@export var photosynthesis_label : RichTextLabel
func getPhotosynthesisCoeffTotal():
	return getLightCoeff() * (airflowLevel * 0.2) * getWateringCoeff()
func updatePhsLabels():
	var text = "[center]"
	text += '[wave]'+getPhaseName()+'[/wave]'
	text += "\n"
	text += "Fotosynteza: x" + str(getPhotosynthesisCoeffTotal()*100) + "%"
	text += "[center]"
	photosynthesis_label.text = text
func _process(delta):
	# Light decay and increasing
	if isLighting:
		light += delta * lightPerSec
	else:
		light = max(light - delta * lightPerSec * 0.25, 0.0)
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
