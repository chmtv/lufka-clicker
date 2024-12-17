extends Node

@export var mainManager : Node
@export var detoxLabel : RichTextLabel

func calcPrestigeReward():
	var thc = mainManager.thcThisPrestige
	return int(
		pow((thc/1000000),1./7.)
	)
func updateLabel():
	var reward = str(calcPrestigeReward())
	detoxLabel.text = "[center][color=#990099]Aktualna Tolerancja: "+str(mainManager.tolerance)+"\n Za zrobienie Detoxu: "+reward+"\n THCpS% za Tolerancję: "+ Globals.float_to_pct_str(mainManager.toleranceMult)

func recalculateToleranceMult():
	mainManager.toleranceMult = 1 + (mainManager.tolerance * 0.042)

# Called after buying the upgrade
func doPrestigeReset():
	# Add tolerance and recalculate the multiplier
	mainManager.tolerance += calcPrestigeReward()
	recalculateToleranceMult()
	# Reset THC, buildings, upgrades, series upgrades and maps
	mainManager.thc = 0
	mainManager.thcThisPrestige = 0
	for building in mainManager.buildings:
		building.level = 0
		building.recalculateCost()
		building.recalculateTHCpS()
	mainManager.boughtUpgradesIds = []
	mainManager.boughtMaps = []
	mainManager.addMap(0, "Piwnica", "piwnica.jpg", "Nie jest najlepsza. ale od czegoś trzeba zacząć")
	mainManager.currentMapPath = "res://Sprites/Maps/piwnica.jpg"
	for upg in mainManager.seriesUpgradesThc:
		upg.level = 0
	# for upg in mainManager.seriesUpgradesLeaves:
	# 	upg.level = 0
	mainManager.recalculateTHCpS()
	mainManager.updateBuildingShop()
	mainManager.updateUpgradesShop()
	mainManager.refreshBuildingsList()
	mainManager.refreshUpgradeEffects()
	mainManager.updateSeriesUpgrades()
	mainManager.updateMapsMenu()
	for i in range(0,7):
		mainManager.buildingsVisualManager.modelVisibilities = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
		mainManager.buildingsVisualManager.refreshModelVisibilities()
	

func _on_detox_update_timeout():
	updateLabel()


func _on_detox_button_pressed():
	doPrestigeReset()
