extends Node

@export var mainManager : Node
@export var detoxLabel : RichTextLabel

func calcPrestigeReward(prevTolerance : int):
	var thc = mainManager.thcLifetime
	var reward = roundi(
		pow( (thc/pow(1000000.,1.)), 1./2. )
	)
	return reward
func updateLabel():
	var reward = calcPrestigeReward(mainManager.tolerance)
	var rewardStr = str(reward)
	detoxLabel.text = (
		"[center][color=#990099]" + 
		"Aktualna Tolerancja: " + str(mainManager.tolerance) +
		"\n Tolerancja po zrobieniu detoxu: " + rewardStr + 
		"\n Spalone THC od ostatniego detoxu: " + mainManager.thcWithNumberAffix(mainManager.thcThisPrestige) +
		"\n THCpS% za Tolerancję: " + Globals.float_to_pct_str(mainManager.toleranceMult)
		)

func recalculateToleranceMult():
	mainManager.toleranceMult = 1 + (mainManager.tolerance * 1)

func recalcToleranceUnlocks():
	if mainManager.toleranceMult >= 50:
		mainManager.GrowingManager.running = true
	else:
		mainManager.GrowingManager.running = false
	mainManager.GrowingManager.set_swiper_visibility()

# Called after buying the upgrade
func doPrestigeReset():
	# Add tolerance and recalculate the multiplier
	mainManager.tolerance = calcPrestigeReward(mainManager.tolerance)
	recalculateToleranceMult()
	# Reset THC, buildings, upgrades, series upgrades and maps
	mainManager.thc = 0
	mainManager.burnPercentage = 0.3
	mainManager.thcThisPrestige = 0
	for building in mainManager.buildings:
		building.level = 0
		building.recalculateCost()
		building.recalculateTHCpS()
	mainManager.boughtUpgradesIds = []
	mainManager.boughtMaps = []
	mainManager.addMap(0, "Piwnica", "piwnica.jpg", "Nie jest najlepsza. ale od czegoś trzeba zacząć")
	mainManager.currentMapPath = "res://Sprites/Maps/piwnica.jpg"
	#for upg in mainManager.seriesUpgradesThc:
	#	upg.level = 0
	# for upg in mainManager.seriesUpgradesLeaves:
	# 	upg.level = 0
	for mapupg in mainManager.Upgrades.mapUpgrades:
		mapupg.bought = false
	for upg in mainManager.Upgrades.upgrades:
		upg.bought = false
	mainManager.Upgrades.mapUpgrades[0].bought = true
	mainManager.recalculateTHCpS()
	mainManager.updateBuildingShop()
	mainManager.updateUpgradesShop()
	mainManager.refreshBuildingsList()
	mainManager.refreshUpgradeEffects()
	mainManager.updateSeriesUpgrades()
	mainManager.updateMapsMenu()
	mainManager.Upgrades.upgrades_prestige()
	mainManager.recalculateTHCpS()
	recalcToleranceUnlocks()
	for i in range(0,7):
		mainManager.buildingsVisualManager.modelVisibilities = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
		mainManager.buildingsVisualManager.refreshModelVisibilities()
	

# Unlocks for prestige tolerance thresholds
# progress bar 
# with sedcondary progress bar



func _on_detox_update_timeout():
	updateLabel()


func _on_detox_button_pressed():
	doPrestigeReset()
