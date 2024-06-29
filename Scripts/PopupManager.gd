extends Control

@export var dialogPopup : Resource

func offlineProgPopup(text):
	var toShow = dialogPopup.instantiate()
	toShow.setText(text)
	add_child(toShow)
