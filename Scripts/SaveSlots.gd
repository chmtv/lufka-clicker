extends Control


const saveslotpath = "user://lufkaClickerSlot.sav"
@export var slotIndicator : Label
func setSlot(slot):
	var saveFile = FileAccess.open(saveslotpath, FileAccess.WRITE)
	saveFile.store_line(JSON.stringify(str(slot)))
	get_tree().quit()
	slotIndicator.text = str(slot)

const saveSlotFilePath = "user://lufkaClickerSlot.sav"
func _ready():
	var saveslotfile = FileAccess.open(saveSlotFilePath, FileAccess.READ)
	var slotnum = "1"
	if saveslotfile:
		slotnum = saveslotfile.get_line()
		slotIndicator.text = slotnum

func setslot1():
	setSlot(1)
	
	

func setslot2():
	setSlot(2)

func setslot3():
	setSlot(3)
