extends Button

func _on_Buy_Button_mouse_entered():
	#if !smokePresent:
		var smoke = load("res://Scenes/buttonSmoke.tscn").instantiate()
		smoke.size = size
		add_child(smoke)
	#	smokePresent = true
		var tween = get_tree().create_tween()
		tween.tween_property(smoke, "modulate:a8", 0, 2).set_trans(Tween.TRANS_QUINT)
		tween.tween_callback(Callable(smoke, "queue_free")).set_delay(2)
