extends Panel

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
var isWatered := false
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

func _process(delta):
	# Light decay and increasing
	if isLighting:
		light += delta * lightPerSec
	else:
		light = max(light - delta * lightPerSec * 0.25, 0.0)
	print(light)
	lightProgressBar.value = light


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
