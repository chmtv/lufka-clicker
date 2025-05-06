extends RichTextLabel

@export var mainManager : Node
@export var growingManager : Node



func createStatsStr():
	
	
	text = (
	# "[center]" +
	"Czas zmarnowany na graniu w Lufka Clicker: " + Globals.seconds_to_time_str(mainManager.playtime) + "\n" +
	"Czas od ostatniego detoxu: " + Globals.seconds_to_time_str(mainManager.playtime_since_detox) + "\n" +
	"THC: " + str(mainManager.thc) + "\n" +
	"THCpS: " + str(mainManager.THCpS) + "\n" +
	#"Zebrane samary: "  + "\n" +
	"Całe spalone THC: " + mainManager.thcWithNumberAffix(mainManager.thcLifetime)  + "\n" +
	"Spalone THC tego od detoxu: " + str(mainManager.thcThisPrestige) + "\n" +
	#"Zebrane krzaki: " + "idk" + "\n" +
	#"Łącznie zebrane liście:" + "idk" + "\n" +
	#"Zrobione detoxy: " + "idk" + "\n" +
	"Łącznie sprzętu: " + str(mainManager.getTotalBuildings()) + "\n" + 
	"Mnożnik z map: " + str(mainManager.globalMultiplier) + "\n" +
	"Mnożnik za liście: " + str(mainManager.growingThcMultMultiplicative * mainManager.growingThcAddMult) + "\n" +
	""
	)
	return text


func _on_upgrade_shop_tab_changed(tab):
	if tab == 4:
		text = createStatsStr()
