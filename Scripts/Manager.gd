extends Node3D

@export var godmode : bool
@export var godTHCmultiplier : float = 10.0
func enableGodmode():
	godmode = true
	# thc = 41900000000000000
<<<<<<< HEAD
	thc = 999999999999
	burnPctPerSec = 0.5
=======
	thc = 999999999999999
	burnPctPerSec = 0.2
>>>>>>> 484e831 (bede zmienial text to sb zapisze progress bo mi sie zjebie cos)
	# burnPctDrainPerSec = 1
func disableGodmode():
	godmode = false
	thc = 0
	loadGame()
# var thc : float = 999999999999
var thc : float = 0
var opalanie : float = 0.0
var burnPercentage = 0.3
var isBurning = false
var burnPctPerSec = 0.015
var burnPctDrainPerSec = 0.01
var burnPctMinimum = 0.25
var THCpS = 0.1
var THCpSWhileBurning = 0
@onready var worldEnvironment = get_node("WorldEnvironment")
<<<<<<< HEAD
=======
@onready var charPortrait = get_node("Burn Button/Stoner Portrait Panel")
>>>>>>> 484e831 (bede zmienial text to sb zapisze progress bo mi sie zjebie cos)
@onready var globalTHCpSLabel = get_node("CanvasLayer/Global THCpS Label")
@onready var upgradesScrollContainer = get_node("UpgradeShopContainer/UpgradeShop/U/ScrollContainer")
@onready var burnButton = get_node("Burn Button")
@onready var buildingsVisualManager = get_node("Burn Button/Buildings")
@onready var NoUpgLabel = get_node("UpgradeShopContainer/UpgradeShop/U/NoUpgLabel")
@onready var ShopTabContainer : TabContainer = get_node("UpgradeShopContainer/UpgradeShop")
var THCpSToDisplay
var elapsedTime = 0

var afterBuyRef = Callable(self, "updateBuildingShop")
<<<<<<< HEAD
var Upgrades = load("res://Scripts/Upgrades.gd").new()
=======
var Upgrades = preload("res://Scripts/Upgrades.gd").new()
>>>>>>> 484e831 (bede zmienial text to sb zapisze progress bo mi sie zjebie cos)
var boughtUpgradesIds = []
var globalAdditiveMultiplier = 1

func thcWithNumberAffix(_thc):
	var affixes = [
		"µg",         # Microgram
		"mg",         # Milligram
		"g",          # Gram
		"kg",         # Kilogram
		"t",          # Metric ton
		"Pg",         # Peta gram (Quadrillion grams)
		"Eg",         # Exa gram (Quintillion grams)
		"Zg",         # Zetta gram (Sextillion grams)
		"Yg",         # Yotta gram (Octillion grams)
		"Yg",         # Yotta gram (Nonillion grams)
		"Dg",         # Deka gram (Ten grams) xd ??
		"Hdag",       # Hecto deka gram (Hundred grams)
		"Kdag",       # Kilo deka gram (Thousand grams)
		# old 
		#"µg",
		#"mg", # 1000
		#"g", # 1000 000
		#"kg", # 1000 000 000
		#"t",
		#"Qd",
		#"Qn",
		#"Sx",
		#"Sp",
		#"O",
		#"N",
		#"Dec",
		#"Undec",
		#"Duodec"
	]
	# Create the initial string from the rounded thc amount
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
	if godmode:
		return
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
	if godmode:
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
<<<<<<< HEAD
	{
		"index": 0,
		"name": "Piwnica",
		"filename":"piwnica.jpg",
		"description": "..."
	}
=======
	
>>>>>>> 484e831 (bede zmienial text to sb zapisze progress bo mi sie zjebie cos)
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
#o
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
func addMap(index, name, fileName, description):
	var map = {
<<<<<<< HEAD
		"index": 0,
		"name": name,
		"filename": fileName,
		"description": description
	}
	boughtMaps.append(map)
@onready var nextMapButton = get_node("Burn Button/NextMapViewport/Control/MapPanel")
func changeMap(map):
	print("chujdsjsdjsdjisdjisdjisdjisdjijisdjisdjisdjisdifjihaaaaaaaaaaaaaaa")
	var mapTemplate = "res://Sprites/Maps/"
	currentMapPath = mapTemplate + map.filename
	worldEnvironment.environment.sky.sky_material.panorama = load(currentMapPath)
	nextMapButton.get_node("Change Button").map = Upgrades.mapUpgrades[map.index+1]
=======
		"index": index,
		"name": name,
		"filename": fileName,
		"description": description,
		"boughtId": boughtMaps.size() - 1
	}
	boughtMaps.append(map)
@onready var nextMapButton = get_node("SubViewportContainer/SubViewport/NextMapButton/MapSwitcher")
@onready var prevMapButton = get_node("SubViewportContainer/SubViewport/PrevMapButton/MapSwitcher")
func changeMap(map):
	var mapTemplate = "res://Sprites/Maps/"
	currentMapPath = mapTemplate + map.filename
	worldEnvironment.environment.sky.sky_material.panorama = load(currentMapPath)
	
	# Set map names on the 3D buttons
	
	
# Set the 3D Buttons for switching maps
func setMapSwitcher(map):
		if map.index+1 < Upgrades.mapUpgrades.size():
			nextMapButton.setName(Upgrades.mapUpgrades[map.index+1].name)
			nextMapButton.mapIndex = map.index+1
		else:
			nextMapButton.setName("")
		if map.index-1 > 0:
			prevMapButton.setName(Upgrades.mapUpgrades[map.index-1].name)
			prevMapButton.mapIndex = map.index-1
		else:
			prevMapButton.setName("")
func changeMapById(id):
	var map = boughtMaps[0]
	if id < boughtMaps.size():
		map = {
			"index": id,
			"filename": Upgrades.mapUpgrades[boughtUpgradesIds[id]].mapPath,
			"name": Upgrades.mapUpgrades[boughtUpgradesIds[id]].name,
			"description": Upgrades.mapUpgrades[boughtUpgradesIds[id]].description,
		}
	changeMap(map)
>>>>>>> 484e831 (bede zmienial text to sb zapisze progress bo mi sie zjebie cos)
func setMapButton(map, button):
	# button.get_node("Change Button").filename = map["filename"]
	button.get_node("Change Button").map = map
	button.get_node("Name").text = map.name
	button.get_node("Description").text = map.description
func updateMapsMenu():
	var mapVBox = get_node("UpgradeShopContainer/UpgradeShop/M/ScrollContainer/VBoxContainer")
	# Reset the VBox to its' initial state
	for n in mapVBox.get_children():
		mapVBox.remove_child(n)
		n.queue_free()
	# Generate and place all the bought map buttons
	for i in boughtMaps.size():
		var currentButton = load("res://Scenes/MapChangeButton.tscn").instantiate()
		setMapButton(boughtMaps[i], currentButton)
		
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
	var upgradeAdditiveMultiplier = 1.0
	var upgradeMultiplicativeMultiplier = 1.0
	var index = 0
	# These properties are used for the progress bar, they show which level upgrade for this building
	# was bought last and at which level is the next one
	var lastUpgLv = 0
	var nextUpgLv = 1
		
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
	func _init(_name = "", _cost = 0, _THCpS = 0, _THCpSWhileBurning = 0, afterBuyFn = "", _costExponent = 1.2, _THCpSExponent = 1, _defaultNextUpgLv = 5):
		
		baseCost = _cost
		name = _name
		baseTHCpS = _THCpS
		baseTHCpSWhileBurning = _THCpSWhileBurning
		costExponent = _costExponent
		THCpSExponent = _THCpSExponent
		afterBuyFnRef = afterBuyFn
		nextUpgLv = _defaultNextUpgLv
		recalculateCost()
		recalculateTHCpS()

var buildings = [
	Building.new("Zapalniczka", 0.5, 0.1, 0, afterBuyRef, 1.31, 5), # 0
	Building.new("Jabłko", 20, 3, 0, afterBuyRef, 1.2, 5), # 1
	Building.new("Lufka", 600, 50, 0, afterBuyRef, 1.14, 5), # 2
	# Building.new("Jedzenie", 1000, 10, 0, afterBuyRef, 1.2), # 3
	Building.new("Wodospad", 160000, 7500, 0, afterBuyRef, 1.14, 5), # 4
	Building.new("Wiadro", 125000000, 4200000, 0, afterBuyRef, 1.09, 5),	# 5
	Building.new("Bongo", 25000000000, 950000000, 0, afterBuyRef, 1.12),	# 6
	Building.new("Waporyzator", 1000000000000, 29000000000, 0, afterBuyRef, 1.11),	# 7
	Building.new("Dab pen",4200000000000000, 200000000000000, 0, afterBuyRef, 1.15),	# 8
	# Building.new("Bongo grawitacyjne", 420000000, 405, 0, afterBuyRef, 1.2), # 9
]


var leafTexture

func getTHC():
	return thc

@onready var thcLabel = get_node("CanvasLayer/THC Points Label")
@onready var burnPctLabel = get_node("CanvasLayer/Percentage")
@onready var burnProgressBar = get_node("Burn Button/Burn Progress")
<<<<<<< HEAD
=======
@onready var burnProgressBarSecondary = get_node("Burn Button/Burn Progress Secondary")
>>>>>>> 484e831 (bede zmienial text to sb zapisze progress bo mi sie zjebie cos)

func _on_BuildingBuy(index):
	thc = buildings[index].buy(thc)
	buildingsVisualManager.setModelVisibility(index)
	# recalculateTHCpS()
	_on_Upg_Button_Disable_timeout()
	
func afterBuildingBuy():
	recalculateTHCpS()
	updateBuildingShop()
	updateUpgradesShop()
	
	
func makeBuildingShop():
	var button = preload("res://Scenes/BuildingButton.tscn")
	for i in buildings.size():
		var building = buildings[i]
		var currentButton = button.instantiate()
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
		# Set the progress bar
		var progressBar = currentButton.get_node("Upgrade Progress")
		progressBar.min_value = building.lastUpgLv
		progressBar.max_value = building.nextUpgLv
		if(building.lastUpgLv == building.nextUpgLv):
			progressBar.value = 0
		else:
			progressBar.value = building.level
		currentButton.get_node("LevelPanel/Level").text = str(building.level)
		currentButton.get_node("Buy Button").connect(
			"BuildingBuy",
			_on_BuildingBuy)
		buildingVBox.add_child(currentButton)
		updateUpgradesShop()
func updateBuildingShop():
	# Reset the VBox to its' initial state
	#for n in buildingVBox.get_children():
	#	buildingVBox.remove_child(n)
	#	n.queue_free()
	# Generate and place all the building buttons
	var buildingNodes = buildingVBox.get_children()
	for i in buildingNodes.size():
		var building = buildings[i]
		var currentButton = buildingVBox.get_child(i)
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
		# Set the progress bar
		var progressBar = currentButton.get_node("Upgrade Progress")
		progressBar.min_value = building.lastUpgLv
		progressBar.max_value = building.nextUpgLv
		progressBar.value = building.level
		currentButton.get_node("LevelPanel/Level").text = str(building.level)
		var curBuyButton = currentButton.get_node("Buy Button")
		if !curBuyButton.is_connected("BuildingBuy", _on_BuildingBuy):
			curBuyButton.connect("BuildingBuy", _on_BuildingBuy)
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
	var visibleUpgradesAmount = upgradeVBox.get_child_count()
	if visibleUpgradesAmount == 0:
		NoUpgLabel.visible = true
		ShopTabContainer.setUpgradesHightlight(false)
	else:
		NoUpgLabel.visible = false
		ShopTabContainer.setUpgradesHightlight(true)
func refreshUpgradeEffects():
	for i in buildings.size():
		buildings[i].upgradeAdditiveMultiplier = 1.0
		buildings[i].upgradeMultiplicativeMultiplier = 1.0
		buildings[i].recalculateTHCpS()
	for i in boughtUpgradesIds.size():
		var curUpg = Upgrades.upgrades[boughtUpgradesIds[i]]
		
		buildings[curUpg.buildingID].upgradeAdditiveMultiplier += curUpg.additiveMultiplier
		if curUpg.multiplicativeMultiplier:
			buildings[curUpg.buildingID].upgradeMultiplicativeMultiplier *= curUpg.multiplicativeMultiplier
		buildings[curUpg.buildingID].recalculateTHCpS()
		# ?????? Kurwa nie działa co ja tu kurwa odjebałem po chuj to tak najebany pisałem w piwnicy ziemniaka jebanej ????????
		
		# Drunk code niggggggaaaaaaaaaaaaaaaaaaaa
		# if(Upgrades.upgrades[boughtUpgradesIds[i]].burnRateMultiplier):
			# Bumbaclot ;dddddddddddddddddddddddd
			# Jestem tak najebany ze nie wiem co robie
			# Kurwa ja pierdodle
			# Kilo dopow moim bagu z twojom starom w hotelu
			# dKIuuuuuuurwa piiiiiiiwnica u Ziemniaka
			# Dziennie 20 mocarzuw
			# Ja kurwa nir ewiem co ja robie jestem tak najebany czego ja kurwa koduje
			# Kurwa 3 piwa w 5 sekund kurwa
				# burnPercentage *= boughtUpgrades[i].burnRateMultiplier
	recalculateTHCpS()
# Adds an upgrade to the bought upgrades list and updates the bought property
@onready var clickStreamPlayer : AudioStreamPlayer = get_node("Buy Sound")
func buyUpgrade(index, isMapUpgrade = false):
	var curUpg
	if isMapUpgrade:
		curUpg = Upgrades.mapUpgrades[index]
	else:
		curUpg = Upgrades.upgrades[index]
		# Set the upgraded building's last upgrade level (for progress bar calculation)
		buildings[curUpg.buildingID].lastUpgLv = curUpg.buildingLevel
		# Set the next upgrade level if it exists (on the next upgrade lmao) and if there is one (shit doesn't work fuck me)
		if Upgrades.upgrades[index+1].buildingID == curUpg.buildingID:
			buildings[curUpg.buildingID].nextUpgLv = Upgrades.upgrades[index+1].buildingLevel
	if(thc >= curUpg.cost):
		thc -= curUpg.cost
		boughtUpgradesIds.append(index)
		if("mapPath" in curUpg):
			addMap(index, curUpg.name, curUpg.mapPath, curUpg.description)
		if(curUpg.globalMultiplier != -1):
			globalAdditiveMultiplier += curUpg.globalMultiplier
		curUpg.bought = true
		Globals.spawnWeedExplosion()
		clickStreamPlayer.play()
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
	# Godmode (disabled on release build)
	print("godmode", godmode)
	if godmode:
		enableGodmode()
	if not OS.is_debug_build():
		disableGodmode()
	
<<<<<<< HEAD
=======

	addMap(0, "Piwnica", "piwnica.jpg", "...")
>>>>>>> 484e831 (bede zmienial text to sb zapisze progress bo mi sie zjebie cos)
	loadGame()
	recalculateTHCpS()
	makeBuildingShop()
	# updateBuildingShop()
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
	# Code for changing the burn percentage based on the percentage
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

<<<<<<< HEAD
=======
func getVisualTHCCoefficient():
	return sqrt( 2 * (thc)/(1000000000000000) )
@onready var burnButtonLabel = get_node("Burn Button/Pal")
func updateBurnButtonLabel():
	var thcCoefficient = getVisualTHCCoefficient()
	burnButtonLabel.text = "  [outline_color=#165300ff] [outline_size=2] [color=green] [center] Pal [/center] [/color] [/outline_size] [/outline_color]"
>>>>>>> 484e831 (bede zmienial text to sb zapisze progress bo mi sie zjebie cos)
func burnChange():
	refreshBurnPctLabel()
	refreshTHCpS()
	burnButton.burnPercentage = burnPercentage
	const max_haze = 0.04
	const burnThreshold = 0.6
<<<<<<< HEAD
=======
	# Visual effects
	var thcCoefficient = getVisualTHCCoefficient()
	charPortrait.burnPercentage = burnPercentage
	charPortrait.refreshPortrait()
	worldEnvironment.get_environment().adjustment_brightness = 0.8 + max(0, burnPercentage - 0.3) * thcCoefficient
	worldEnvironment.get_environment().adjustment_contrast = 1 + max(0, burnPercentage - 0.7) * 2 * thcCoefficient
	worldEnvironment.get_environment().adjustment_saturation = 1 + max(0, burnPercentage - 0.85) * 5 * thcCoefficient
>>>>>>> 484e831 (bede zmienial text to sb zapisze progress bo mi sie zjebie cos)
	if burnPercentage > burnThreshold:
		
		var density = ( (burnPercentage - burnThreshold)/(1-burnThreshold) ) * max_haze
		print("Current haze density: ", density)
		# var tween = get_tree().create_tween()
		# tween.tween_property(worldEnvironment.environment, "volumetric_fog_density", density, 0.8)
		worldEnvironment.environment.fog_density = density
	else:
		# tween.tween_property(worldEnvironment.environment, "volumetric_fog_density", 0.01, 0.8)
		worldEnvironment.environment.fog_density = 0.01
	buildingsVisualManager.burnPercentage = burnPercentage
func refreshBurnPctLabel():
	burnPctLabel.text = str(burnPercentage * 100) + "%"
<<<<<<< HEAD
	burnProgressBar.value = burnPercentage * 100
=======
	burnProgressBar.value = burnPercentage * 200
	burnProgressBarSecondary.value = (burnPercentage - 0.5) * 200
>>>>>>> 484e831 (bede zmienial text to sb zapisze progress bo mi sie zjebie cos)
func _on_burn_press():
	pass
	# Old code for pressing the button to gain burning instead of holding the button
	# burnPercentage = min(burnPercentage + burnPctPerClick, 1)

func addTHC(amount):
	# Change the THCps label's text
	globalTHCpSLabel.text = "THCpS: " + thcWithNumberAffix(THCpS/burnPercentage) + "\n (" + thcWithNumberAffix(THCpS) + ")" + " "
	
	thc += godTHCmultiplier * amount
	
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
<<<<<<< HEAD
=======


func _on_map_switcher_map_change(map):
	pass # Replace with function body.
>>>>>>> 484e831 (bede zmienial text to sb zapisze progress bo mi sie zjebie cos)
