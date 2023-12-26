extends Button

signal MapChange(fileName)
var fileName = 0

func _on_Buy_Button_pressed():
	emit_signal("MapChange", fileName)
