extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func DeleteSave():
	# There might be a better way to choose the dir path but whatever
	var diracc = DirAccess.open("user://")
	diracc.remove(Globals.saveFilePath)
	get_tree().quit()
	pass


func _on_pressed():
	# To be later changed to some popup
	DeleteSave()
