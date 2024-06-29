extends Button

signal BuildingBuy(index, currency)
var index = 0

var currency = Globals.CURRENCIES.THC
@onready var clickStreamPlayer : AudioStreamPlayer = get_node("Buy Sound")
@export var smokePanel : Node
@export var costLabel : Label
@export var buttonSmoke : Node
func _on_Buy_Button_pressed():
	# Spawn weed explosion
	var mousePos = get_global_mouse_position()
	Globals.spawnWeedExplosion(mousePos)
	if buttonSmoke:
		buttonSmoke.buyAnimation()
	clickStreamPlayer.play()
	emit_signal("BuildingBuy", index, currency)
var smokePresent = false

func _unhandled_input(event):
	if event is InputEventScreenTouch and event.pressed == true:
		# Globals.spawnWeedExplosion(event.position)
		pass

const animLength = 1.75
@onready var burnTimer = get_tree().create_timer(animLength)
func showSmoke():
	var smoke = load("res://Scenes/buttonSmoke.tscn").instantiate()
	smoke.size = size
	add_child(smoke)
	var tween = get_tree().create_tween()
	tween.tween_property(smoke, "modulate:a8", 0, 2).set_trans(Tween.TRANS_QUINT)
	tween.tween_callback(Callable(smoke, "queue_free")).set_delay(2)
func showCost(costStr : String):
	costLabel.text = costStr

@export var levelLabel : Label
# Func that shows data of a building like level, description etc
# It isn't used by the original code because i didn't think of an actual good way of doing this earlier and i'm NOT refactoring this BULLSHIT code
func showData(building):
	levelLabel.text = str(building.level)

func _on_Buy_Button_mouse_entered():
	pass
	# I'm disabling the hover smoke because as of now it looks like garbage 
	# and on Godot 4 it drops performance by about 0.4s per building buy
	#  showSmoke()
