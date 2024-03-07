extends Button

signal UpgradeBuy(index, isMapUpgrade)
var index = 0
var isMapUpgrade = false


func _on_Buy_Button_pressed():
	emit_signal("UpgradeBuy", index, isMapUpgrade)
	
