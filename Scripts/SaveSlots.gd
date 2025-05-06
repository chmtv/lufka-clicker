extends Control


const saveslotpath = "user://lufkaClickerSlot.sav"
@export var slotIndicator : Label
func setSlot(slot = ""):
	var saveFile = FileAccess.open(saveslotpath, FileAccess.WRITE)
	saveFile.store_line(str(slot))
	get_tree().quit()
	slotIndicator.text = str(slot)
	if not slot: # checks if the slot is empty (case of slot 1)
		slotIndicator.text = "1"

const saveSlotFilePath = "user://lufkaClickerSlot.sav"
func _ready():
	var saveslotfile = FileAccess.open(saveSlotFilePath, FileAccess.READ)
	var slotnum = "1"
	if saveslotfile:
		slotnum = saveslotfile.get_line()
		slotIndicator.text = slotnum

func setslot1():
	setSlot()
	
	

func setslot2():
	setSlot(2)

func setslot3():
	setSlot(3)
