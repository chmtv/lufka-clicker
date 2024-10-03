extends RichTextLabel

@export var mainManager : Node
@export var growingManager : Node

func updateStats():
	
	
	text = (
	"[center]" +
	"THC: " +
	"THCpS: " +
	"Całe spalone THC: " +
	"Spalone THC tego od detoxu: " +
	"Zebrane krzaki: " + 
	"Łącznie zebrane liście:" +
	"Zrobione detoxy: " +
	"Łącznie sprzętu: " + 
	"Mnożnik z map: " + 
	"Mnożnik z ulepszeń za THC: " +
	"Mnożnik za liście: " +
	""
	)
