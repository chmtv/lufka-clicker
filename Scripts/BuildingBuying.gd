extends Button

signal BuildingBuy(index)
var index = 0

@onready var clickStreamPlayer : AudioStreamPlayer = get_node("Buy Sound")
@export var costLabel : Label
@export var burnDownShaderMaterial : ShaderMaterial
func _on_Buy_Button_pressed():
	# Spawn weed explosion
	var mousePos = get_global_mouse_position()
	Globals.spawnWeedExplosion(mousePos)
	buyAnimation()
	clickStreamPlayer.play()
	emit_signal("BuildingBuy", index)
var smokePresent = false

func _unhandled_input(event):
	if event is InputEventScreenTouch and event.pressed == true:
		# Globals.spawnWeedExplosion(event.position)
		pass

const animLength = 1.75
@onready var burnTimer = get_tree().create_timer(animLength)
func setFireZoom(zoom):
	burnDownShaderMaterial.set_shader_parameter("zoom", zoom)
func buyAnimation():
	var prevMaterial = material
	material = burnDownShaderMaterial
	
	create_tween().tween_method(setFireZoom,2.5,0.0,animLength).set_trans(Tween.TRANS_QUAD)
	# For some reason it breaks the position of the button,
	# possibly because of some code in the building button refresher, idk
	# $AnimationPlayer.play("cardMove")
	burnTimer.time_left = animLength
	await burnTimer.timeout
	material = null
func showSmoke():
	var smoke = load("res://Scenes/buttonSmoke.tscn").instantiate()
	smoke.size = size
	add_child(smoke)
	var tween = get_tree().create_tween()
	tween.tween_property(smoke, "modulate:a8", 0, 2).set_trans(Tween.TRANS_QUINT)
	tween.tween_callback(Callable(smoke, "queue_free")).set_delay(2)
func showCost(costStr : String):
	costLabel.text = costStr

func _on_Buy_Button_mouse_entered():
	pass
	# I'm disabling the hover smoke because as of now it looks like garbage 
	# and on Godot 4 it drops performance by about 0.4s per building buy
	#  showSmoke()
