extends Node3D

var thc : float = 999999999999
var opalanie : float = 0.0
var burnPercentage = 0.3
var isBurning = false
var burnPctPerSec = 2.015
var burnPctDrainPerSec = 0.01
var burnPctMinimum = 0.25
var THCpS = 0.1
var THCpSWhileBurning = 0
@onready var globalTHCpSLabel = get_node("CanvasLayer/Global THCpS Label")
@onready var upgradesScrollContainer = get_node("UpgradeShopContainer/UpgradeShop/U/ScrollContainer")
@onready var burnButton = get_node("Burn Button")
@onready var buildingsVisualManager = get_node("Burn Button/Buildings")
var THCpSToDisplay
var elapsedTime = 0

var afterBuyRef = Callable(self, "updateBuildingShop")
var Upgrades = load("res://Scripts/Upgrades.gd").new()
var boughtUpgradesIds = []
var globalAdditiveMultiplier = 1

func thcWithNumberAffix(_thc):
	var affixes = [
		"µg",
		"mg", # 1000
		"g", # 1000 000
		"kg", # 1000 000 000
		"t",
		"Qd",
		"Qn",
		"Sx",
		"Sp",
		"O",
		"N",
		"Dec",
		"Undec",
		"Duodec"
	]
	var result = str(_thc)
	for i in affixes.size():
		if _thc / pow(10, 3*(i)) > 1:
			var thcNumWithoutAffix = snapped(_thc / pow(10, 3*i), 0.0001)
			result = str(thcNumWithoutAffix) + affixes[i]
		elif _thc < 1000: # In case of the first affix
			var thcNumWithoutAffix = snapped(_thc, 0.0001)
			result = str(thcNumWithoutAffix) + affixes[0]
	return result

const saveFilePath = "user://lufkaClicker.sav"
func saveGame():
	var buildingLevels = []
	for building in buildings:
		buildingLevels.append(building.level)
	var saveData = {
		"buildingLevels": buildingLevels,
		"boughtUpgradesIds": boughtUpgradesIds,
		"thc": thc,
	}
	var saveFile = FileAccess.open(saveFilePath, FileAccess.WRITE)
	saveFile.store_line(JSON.new().stringify(saveData))
func loadGame():
	# Uncomment this to make the game NOT load the save file
	return
	var saveFile = FileAccess.open(saveFilePath, FileAccess.READ)
	if not saveFile:
		return
	
	
	var test_json_conv = JSON.new()
	test_json_conv.parse(saveFile.get_line())
	var dataToLoad = test_json_conv.get_data()
	# the -1 is a quick fix i have no fucking idea if it works properly but gets 
	# rid of the error so i guess that's good
	for i in buildings.size() - 1:
		buildings[i].level = dataToLoad["buildingLevels"][i]
		buildings[i].recalculateCost()
		buildings[i].recalculateTHCpS()
		# Make the model showing the building visible if it is bought
		if buildings[i].level > 0:
			buildingsVisualManager.setModelVisibility(i)
	boughtUpgradesIds = dataToLoad["boughtUpgradesIds"]
	for i in boughtUpgradesIds.size():
		Upgrades.upgrades[boughtUpgradesIds[i]].bought = true
	
	thc = dataToLoad["thc"]
	updateBuildingShop()
	updateUpgradesShop()
	refreshBuildingsList()
	refreshUpgradeEffects()
	updateMapsMenu()
	recalculateTHCpS()

var boughtMaps = [
	{
		"name": "Piwnica",
		"filename":"piwnica.jpg"
	}
]
# The plugin that makes Discord display the played game along with some stats doesn't seem
# To work od Godot 4 so I'm not using it for now.
#func update_Discord() -> void:
#	var activity = Discord.Activity.new()
#	activity.set_type(Discord.ActivityType.Playing)
#	activity.set_state("Pali konopie")
#	activity.set_details("THCpS: " + thcWithNumberAffix(THCpS))
#
#	var assets = activity.get_assets()
#	assets.set_large_image("lufkadiscord")
#	assets.set_large_text("W3333333d")
#	# assets.set_small_image("rpcicon")
#	# assets.set_small_text("W3333333d")
#
#	var timestamps = activity.get_timestamps()
#	timestamps.set_start(OS.get_unix_time() - elapsedTime)
#
#
#	var result = yield(Discord.activity_manager.update_activity(activity), "result").result
	# na chuj mi obsluga bledow!!!!!!!
	# if result != Discord.Result.Ok:
		# push_error(str(result))


var currentMapPath = "res://Sprites/Maps/piwnica.jpg"

var buildingButtonList = []
var buildingVBoxPath = "UpgradeShopContainer/UpgradeShop/S/ScrollContainer/VBoxContainer"
@onready var buildingVBox = get_node(buildingVBoxPath)
func addMap(name, fileName):
	var map = {
		"name": name,
		"filename": fileName
	}
	boughtMaps.append(map)
func changeMap(fileName):
	var mapTemplate = "res://Sprites/Maps/"
	currentMapPath = mapTemplate + fileName
	get_node("WorldEnvironment").environment.sky.sky_material.panorama = load(currentMapPath)
func updateMapsMenu():
	var mapVBox = get_node("UpgradeShopContainer/UpgradeShop/M/ScrollContainer/VBoxContainer")
	# Reset the VBox to its' initial state
	for n in mapVBox.get_children():
		mapVBox.remove_child(n)
		n.queue_free()
	# Generate and place all the bought map buttons
	for i in boughtMaps.size():
		var currentButton = load("res://Scenes/MapChangeButton.tscn").instantiate()
		currentButton.get_node("Change Button").fileName = boughtMaps[i]["filename"]
		currentButton.get_node("Name").text = boughtMaps[i].name
		currentButton.get_node("Change Button").connect(
			"MapChange", 
			changeMap)
		mapVBox.add_child(currentButton)
	# Generate the map buy buttons
	for i in Upgrades.mapUpgrades.size():
		if !Upgrades.mapUpgrades[i].bought:
			var currentButton = load("res://Scenes/UpgradeButton.tscn").instantiate()
			currentButton.get_node("Buy Button").index = i
			currentButton.get_node("Buy Button").isMapUpgrade = true
			currentButton.get_node("Name").text = Upgrades.mapUpgrades[i].name
			var THCpStext = ""
			if Upgrades.mapUpgrades[i].globalMultiplier:
				THCpStext += "+" + str(Upgrades.mapUpgrades[i].globalMultiplier * 100) + "%" + " THCpS "
			else:
				THCpStext = ""
			currentButton.get_node("THCpS").text = THCpStext
			currentButton.get_node("Buy Button").text = thcWithNumberAffix(Upgrades.mapUpgrades[i].cost)
			currentButton.get_node("Buy Button").connect(
				"UpgradeBuy", 
				_on_UpgradeBuy)
			mapVBox.add_child(currentButton)
		


class Building:
	
	var level = 0
	var baseCost
	var cost
	var THCpS = 0
	var baseTHCpS = 0
	var THCpSWhileBurning = 0
	var baseTHCpSWhileBurning = 0
	var costExponent
	var THCpSExponent
	var name = ""
	var afterBuyFnRef
	var upgradeAdditiveMultiplier = 1
	var upgradeMultiplicativeMultiplier = 1
	var index = 0
		
	# buys and returns the new currency amount
	func buy(thc):
		if thc >= cost:
			
			var newTHC = thc - cost
			level += 1
			recalculateCost()
			recalculateTHCpS()
			afterBuyFnRef.call()
			return newTHC
		else:
			return thc
			
	func recalculateCost():
		cost = snapped(baseCost + baseCost * pow(level, costExponent), 0.02)
	func recalculateTHCpS():
		THCpS = baseTHCpS * level * upgradeAdditiveMultiplier * upgradeMultiplicativeMultiplier
		THCpSWhileBurning = baseTHCpSWhileBurning * level * upgradeAdditiveMultiplier * upgradeMultiplicativeMultiplier
	func _init(_name = "", _cost = 0, _THCpS = 0, _THCpSWhileBurning = 0, afterBuyFn = "", _costExponent = 1.2, _THCpSExponent = 1):
		
		baseCost = _cost
		name = _name
		baseTHCpS = _THCpS
		baseTHCpSWhileBurning = _THCpSWhileBurning
		costExponent = _costExponent
		THCpSExponent = _THCpSExponent
		afterBuyFnRef = afterBuyFn
		recalculateCost()
		recalculateTHCpS()

var buildings = [
	Building.new("Zapalniczka", 0.5, 0.1, 0, afterBuyRef, 1.3), # 0
	Building.new("Jabłko", 20, 3, 0, afterBuyRef, 1.2), # 1
	Building.new("Lufka", 750, 100, 0, afterBuyRef, 1.17), # 2
	# Building.new("Jedzenie", 1000, 10, 0, afterBuyRef, 1.2), # 3
	Building.new("Wodospad", 10000, 1250, 0, afterBuyRef, 1.15), # 4
	Building.new("Wiadro", 30000, 25, 0, afterBuyRef, 1.2),	# 5
	Building.new("Bongo", 1000000, 75, 0, afterBuyRef, 1.2),	# 6
	Building.new("Waporyzator", 20000000, 125, 0, afterBuyRef, 1.2),	# 7
	Building.new("Bongo grawitacyjne", 20000000, 125, 0, afterBuyRef, 1.2),	# 8
	Building.new("Sztuczne Płuca", 420000000, 405, 0, afterBuyRef, 1.2), # 9
]


var leafTexture

func getTHC():
	return thc

@onready var thcLabel = get_node("CanvasLayer/THC Points Label")
@onready var burnPctLabel = get_node("CanvasLayer/Percentage")
@onready var burnProgressBar = get_node("Burn Button/Burn Progress")

func _on_BuildingBuy(index):
	thc = buildings[index].buy(thc)
	buildingsVisualManager.setModelVisibility(index)
	recalculateTHCpS()
	_on_Upg_Button_Disable_timeout()
	
func afterBuildingBuy():
	recalculateTHCpS()
	updateBuildingShop()
	updateUpgradesShop()
	
	

func updateBuildingShop():
	# Reset the VBox to its' initial state
	for n in buildingVBox.get_children():
		buildingVBox.remove_child(n)
		n.queue_free()
	# Generate and place all the building buttons
	for i in buildings.size():
		var building = buildings[i]
		var currentButton = preload("res://Scenes/BuildingButton.tscn").instantiate()
		currentButton.get_node("Buy Button").index = i
		currentButton.get_node("Name").text = building.name
		var thcDifference = building.baseTHCpS * building.upgradeAdditiveMultiplier * building.upgradeMultiplicativeMultiplier
		var thcDiffStr = thcWithNumberAffix(thcDifference)
		var THCpSLabel = currentButton.get_node("THCpS")
		THCpSLabel.text = "[center]" + thcWithNumberAffix(building.THCpS) + ("\n[color=#555555] (+%s)" % thcDiffStr) + "[/color] \n " + "[/center]"
		
		if building.THCpSWhileBurning:
			THCpSLabel.clear()
			thcDifference = building.baseTHCpSWhileBurning * building.upgradeAdditiveMultiplier * building.upgradeMultiplicativeMultiplier
			thcDiffStr = thcWithNumberAffix(thcDifference)
			
			THCpSLabel.text = thcWithNumberAffix(building.THCpSWhileBurning) + ("[color=#555555] (+%s)" % thcDiffStr) + "[/color] Akt. THCpS "
		currentButton.get_node("Buy Button").text = thcWithNumberAffix(building.cost)
		currentButton.get_node("LevelPanel/Level").text = str(building.level)
		currentButton.get_node("Buy Button").connect(
			"BuildingBuy",
			_on_BuildingBuy)
		buildingVBox.add_child(currentButton)
		updateUpgradesShop()
# UPGRADES CODE
func updateUpgradesShop():
	var upgScrollContainer = get_node("UpgradeShopContainer/UpgradeShop/U/ScrollContainer")
	var upgradeVBox = get_node("UpgradeShopContainer/UpgradeShop/U/ScrollContainer/VBoxContainer")
	upgradeVBox.name = "VBoxContainer"
	
	# Reset the VBox to its' initial state
	for n in upgradeVBox.get_children():
		upgradeVBox.remove_child(n)
		n.queue_free()
	
	
	
	var buttonNode = load("res://Scenes/UpgradeButton.tscn")
	# Generate and place all the upgrade buttons
	for i in Upgrades.upgrades.size():
		var upgrade = Upgrades.upgrades[i]
		var buildingIndex = upgrade.buildingID
		var buildingLevel = upgrade.buildingLevel
		if buildings[buildingIndex].level >= buildingLevel and not upgrade.bought:
				var currentButton = buttonNode.instantiate()
				currentButton.get_node("Buy Button").index = i
				currentButton.get_node("Name").text = upgrade.name
				var THCpStext = buildings[upgrade.buildingID].name + " "
				if upgrade.additiveMultiplier:
					THCpStext += "+" + str(upgrade.additiveMultiplier * 100) + "%" + " THCpS "
				if upgrade.multiplicativeMultiplier:
					THCpStext += str(upgrade.multiplicativeMultiplier * 100) + "%" + " THCpS"
				currentButton.get_node("THCpS").text = THCpStext
				currentButton.get_node("Description").text = upgrade.description
				currentButton.get_node("Buy Button").text = thcWithNumberAffix(upgrade.cost)
				currentButton.get_node("Buy Button").connect(
					"UpgradeBuy",
					_on_UpgradeBuy)
				upgradeVBox.add_child(currentButton)
func refreshUpgradeEffects():
	for i in buildings.size():
		buildings[i].upgradeAdditiveMultiplier = 1.0
		buildings[i].upgradeMultiplicativeMultiplier = 1.0
	for i in boughtUpgradesIds.size():
		var curUpg = Upgrades.upgrades[boughtUpgradesIds[i]]
		
		buildings[curUpg.buildingID].upgradeAdditiveMultiplier += curUpg.additiveMultiplier
		buildings[curUpg.buildingID].upgradeMultiplicativeMultiplier += curUpg.multiplicativeMultiplier
		buildings[curUpg.buildingID].recalculateTHCpS()
	recalculateTHCpS()
# Adds an upgrade to the bought upgrades list and updates the bought property
func buyUpgrade(index, isMapUpgrade = false):
	var curUpg
	if isMapUpgrade:
		curUpg = Upgrades.mapUpgrades[index]
	else:
		curUpg = Upgrades.upgrades[index]
	if(thc >= curUpg.cost):
		thc -= curUpg.cost
		boughtUpgradesIds.append(index)
		if("mapPath" in curUpg):
			addMap(curUpg.name, curUpg.mapPath)
		if(curUpg.globalMultiplier):
			globalAdditiveMultiplier += curUpg.globalMultiplier
		curUpg.bought = true
		refreshUpgradeEffects()
		updateBuildingShop()
		updateMapsMenu()
		updateUpgradesShop()

func _on_UpgradeBuy(index, isMapUpg):
	buyUpgrade(index, isMapUpg)
		

func recalculateTHCpS():
	THCpSWhileBurning = 0
	THCpS = 0.1
	for i in buildings.size():
		THCpSWhileBurning += buildings[i].THCpSWhileBurning
		THCpS += buildings[i].THCpS
		# update_Discord()
	THCpS = THCpS * globalAdditiveMultiplier * burnPercentage
func _ready():
	leafTexture = load("res://Sprites/cannabis.png")
	loadGame()
	recalculateTHCpS()
	updateBuildingShop()
	updateUpgradesShop()
	updateMapsMenu()
	refreshBuildingsList()
	
func refreshBuildingsList():
	var buildingListNode = get_node(buildingVBoxPath)
	buildingButtonList = []
	for i in buildingListNode.get_child_count():
		var button = {"index": i, "cost": buildings[i].cost, "name": buildings[i].name}
		if thc/2 > buildings[i].cost:
			buildingButtonList.append(button)
func _process(delta):
	if isBurning:
		var added = burnPercentage + burnPctPerSec * delta
		burnPercentage = min(added, 1)
	else:
		var drained = burnPercentage - burnPctDrainPerSec * delta
		burnPercentage = max(burnPctMinimum, drained)
	burnChange()
	elapsedTime += delta
	THCpSToDisplay = THCpS
	addOpalanie(burnPercentage*delta*0.01)
	addTHC(THCpS*delta)

func _on_Topek_burning(delta):
	THCpSToDisplay = THCpS + THCpSWhileBurning
	addTHC(THCpSWhileBurning * delta)

func THCpStext(THCpS):
	return "+" + "dsadsadsa" + "%" + " THCpS "

func refreshTHCpS():
	recalculateTHCpS()

# Pressing the button code
func burnChange():
	refreshBurnPctLabel()
	refreshTHCpS()
	burnButton.burnPercentage = burnPercentage
	buildingsVisualManager.burnPercentage = burnPercentage
func refreshBurnPctLabel():
	burnPctLabel.text = str(burnPercentage * 100) + "%"
	burnProgressBar.value = burnPercentage * 100
func _on_burn_press():
	isBurning = true
	# burnPercentage = min(burnPercentage + burnPctPerClick, 1)
	# 
 

func addTHC(amount):
	globalTHCpSLabel.text = thcWithNumberAffix(THCpS) + " THCpS"
	
	thc += amount
	
	var thcTemplate = "%s"
	
	thcLabel.text = (thcTemplate % thcWithNumberAffix(snapped(thc, 0.01)))

func addOpalanie(amount):
	opalanie += amount
	buildingsVisualManager.setOpalanie(opalanie)

# Timer callback function to gray-out Buy Buttons when they're not affordable
func _on_Upg_Button_Disable_timeout():
	# Buildings
	refreshBuildingsList()
	for i in buildings.size():
		#var index = buildings[i].index
		var index = i
		var cost = buildings[index].cost
		# Check whether the building is outside of the level range and hide it if it is so.
		if i > 1 and buildings[index - 2].level == 0:
			buildingVBox.get_child(index).visible = false
		else:
			buildingVBox.get_child(index).visible = true
		if cost > thc:
			buildingVBox.get_child(index).get_node("Buy Button").disabled = true
		else:
			buildingVBox.get_child(index).get_node("Buy Button").disabled = false
	# kurwa nie chce mi sie w chuj
	var upgradesNodes = upgradesScrollContainer.get_children()[0].get_children()
	for i in upgradesNodes.size():
		var upgIndex = upgradesNodes[i].get_node("Buy Button").index
		if Upgrades.upgrades[upgIndex].cost > thc:
			upgradesNodes[i].get_node("Buy Button").disabled = true
		else:
			upgradesNodes[i].get_node("Buy Button").disabled = false
	
		


func _on_SaveTimer_timeout():
	saveGame()






func handle_Burn_Button_hold():
	isBurning = true
func handle_Burn_Button_release():
	isBurning = false
