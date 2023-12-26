extends Button

signal BuildingBuy(index)
var index = 0

func _on_Buy_Button_pressed():
	# showSmoke()
	emit_signal("BuildingBuy", index)

var smokePresent = false

func showSmoke():
	var smoke = load("res://Scenes/buttonSmoke.tscn").instantiate()
	smoke.size = size
	add_child(smoke)
	var tween = get_tree().create_tween()
	tween.tween_property(smoke, "modulate:a8", 0, 2).set_trans(Tween.TRANS_QUINT)
	tween.tween_callback(Callable(smoke, "queue_free")).set_delay(2)

func _on_Buy_Button_mouse_entered():
	pass
	# I'm disabling the hover smoke because as of now it looks like garbage 
	# and on Godot 4 it drops performance by about 0.4s per building buy
	#  showSmoke()
