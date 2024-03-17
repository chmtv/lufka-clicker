extends Button

signal MapChange(map)
var map = 0

func _on_Buy_Button_pressed():
	print("map signal triggered")
	emit_signal("MapChange", map)

# For testing purposes
func _on_map_panel_mouse_entered():
	print("map panel mouse entered")
