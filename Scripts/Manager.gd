extends Node3D

@export var godmode : bool
@export var godTHCmultiplier : float = 10.0
func enableGodmode():
	godmode = true
	GrowingManager.lightGodMult = 50
	GrowingManager.phsMult = 1000
	samaraManager.minTime = 0
	samaraManager.maxTime = 12
	thc = 1000000050000000000000000000.0
	burnPctPerSec = 0.2
	# burnPctDrainPerSec = 1
func disableGodmode():
	godmode = false
	thc = 0.0
	GrowingManager.lightGodMult = 1
	GrowingManager.phsMult = 1
	samaraManager.minTime = 45
	samaraManager.maxTime = 90
	loadGame()
# var thc : float = 999999999999
var thc : float = 0
var thcThisPrestige : float = 0
var toleranceMult : float = 1
var tolerance : int = 0
var opalanie : float = 0.0
var burnPercentage = 0.3
var isBurning = false
var burnPctPerSec = 0.015
var burnPctDrainPerSec = 0.01
var burnPctMinimum = 0.25
var THCpS = 0.1
var THCpSWhileBurning = 0

var samaraTHCPSbonus = 1.0
var samaraBurnPctBonus = 1.0
func instaBank():
	addTHC(THCpS * 60)

@onready var worldEnvironment = get_node("WorldEnvironment")
@export var charPortrait : Panel
@onready var globalTHCpSLabel = get_node("CanvasLayer/Global THCpS Label")
@export var upgradesScrollContainer : VBoxContainer # get_node("UpgradeShopContainer/UpgradeShop/U/ScrollContainer")
@onready var burnButton : Button = get_node("Burn Button") 
@onready var buildingsVisualManager = get_node("Burn Button/Buildings")
@export var NoUpgLabel : Node
@onready var ShopTabContainer : TabContainer = get_node("UpgradeShopContainer/UpgradeShop")
@onready var subViewportContainer = get_node("SubViewportContainer");
@export var samaraManager : Node
@export var uiMover : Node
@export var popupManager : Node
@export var prestigeManager : Node
var THCpSToDisplay
var elapsedTime = 0

var afterBuyRef = Callable(self, "updateBuildingShop")
var Upgrades = preload("res://Scripts/Upgrades.gd").new()
var boughtUpgradesIds = []
var globalAdditiveMultiplier = 1
var lastDate # = Time.get_unix_time_from_system()

func thcWithNumberAffix(_thc, add_affix = true):
	var affixes = [
		"µg",         # Microgram
		"mg",         # Milligram
		"g",          # Gram
		"kg",         # Kilogram
		"t",          # Metric ton
		"Kt",         # Peta gram (Quadrillion grams)
		"Mt",         # Exa gram (Quintillion grams)
		"Gt",         # Zetta gram (Sextillion grams)
		"Tt",         # Yotta gram (Octillion grams)
		"Pt",         # Yotta gram (Nonillion grams)
		"Et",         # Deka gram (Ten grams) xd ??
		"Zt",       # Hecto deka gram (Hundred grams) tar
		"Yt",       # Kilo deka gram (Thousand grams)
		"Zt",
		"αg",
		"βg",
		"γg",
		"δg",
		"εg",
		"ζg",
		"ηg",
		"θg",
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

		#"Undec",
		#"Duodec"
	]
	# Create the initial string from the rounded thc amount
	var result = str(_thc)
	for i in affixes.size():
		if _thc / pow(10, 3*(i)) > 1:
			var thcNumWithoutAffix = snapped(_thc / pow(10, 3*i), 0.01)
			result = str(thcNumWithoutAffix)
			if add_affix: 
				result += affixes[i]
		elif _thc < 1000: # In case of the first affix
			var thcNumWithoutAffix = snapped(_thc, 0.01)
			result = str(thcNumWithoutAffix)
			if add_affix:
				result += affixes[0]
	return result

const saveFilePath = "user://lufkaClicker.sav"
func saveGame():
	if godmode:
		return
	print("Saving game")
	var buildingLevels = []
	var seriesThcLevels = []
	var seriesLeafLevels = []
	for building in buildings:
		buildingLevels.append(building.level)
	for upg in seriesUpgradesThc:
		seriesThcLevels.append(upg.level)
	for upg in seriesUpgradesLeaves:
		seriesLeafLevels.append(upg.level)
	lastDate = Time.get_unix_time_from_system()
	var saveData = {
		"buildingLevels": buildingLevels,
		"boughtUpgradesIds": boughtUpgradesIds,
		"thc": thc,
		"thcThisPrestige": thcThisPrestige,
		"tolerance": tolerance,
		"lastDate": lastDate,
		"seriesThcLevels": seriesThcLevels,
		"seriesLeafLevels": seriesLeafLevels,
		"leaves": leaves,
		"phs": GrowingManager.get_phs()
	}
	var saveFile = FileAccess.open(saveFilePath, FileAccess.WRITE)
	saveFile.store_line(JSON.stringify(saveData))
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
	for i in seriesUpgradesThc.size():
		seriesUpgradesThc[i].level = dataToLoad["seriesThcLevels"][i]
		seriesUpgradesThc[i].recalculateCost()
		seriesUpgradesThc[i].recalculateTHCpS()
	for i in seriesUpgradesLeaves.size():
		seriesUpgradesLeaves[i].level = dataToLoad["seriesLeafLevels"][i]
		seriesUpgradesLeaves[i].recalculateCost()
		seriesUpgradesLeaves[i].recalculateTHCpS()
	boughtUpgradesIds = dataToLoad["boughtUpgradesIds"]
	for i in boughtUpgradesIds.size():
		Upgrades.upgrades[boughtUpgradesIds[i]].bought = true
	
	thc = dataToLoad["thc"]
	thcThisPrestige = dataToLoad["thcThisPrestige"]
	tolerance = dataToLoad["tolerance"]
	leaves = dataToLoad["leaves"]
	GrowingManager.set_leaves(leaves)
	print("jeubany phs to:", dataToLoad["phs"])
	GrowingManager.set_phs(dataToLoad["phs"])
	lastDate = dataToLoad["lastDate"]
	updateBuildingShop()
	updateUpgradesShop()
	refreshBuildingsList()
	refreshUpgradeEffects()
	updateSeriesUpgrades()
	updateMapsMenu()
	recalculateTHCpS()

func offlineProgression():
	
	var deltaTime = 0
	var curTime = Time.get_unix_time_from_system()
	
	if lastDate:
		deltaTime = curTime - lastDate
		print("Offline progression deltaTime = ", deltaTime)
	if deltaTime < 15:
		return
	var offlineTHC = THCpS * deltaTime
	var thcToDisplay = thcWithNumberAffix(offlineTHC)
	addTHC(offlineTHC)
	var timeDict = Time.get_datetime_dict_from_unix_time(deltaTime)
	print(timeDict)
	var minutes = timeDict.minute
	var hours = timeDict.hour
	var seconds = timeDict.second
	var days = timeDict.day - 1
	
	var minutesStr = ("%smin" % minutes) if minutes else ""
	var hoursStr = ("%sgodz" % hours) if hours else ""
	var secondsStr = ("%ss" % seconds) if seconds else ""
	var daysStr = ("%sdni" % days) if days else ""
	
	var text : String = "Witaj spowrotem! Nie było cię przez[color=yellow][wave]%s %s %s %s[/wave][/color] \n Zdobyłeś przez ten czas %s THC" % [daysStr, hoursStr, minutesStr, secondsStr, thcToDisplay]
	popupManager.offlineProgPopup(text)


func _notification(what: int):
	if what == NOTIFICATION_APPLICATION_FOCUS_IN:
		offlineProgression()

var boughtMaps = [
	
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
var buildingVBoxPath = "UpgradeShopContainer/UpgradeShop/S/VBoxContainer"
@export var buildingVBox : Node # = get_node(buildingVBoxPath)
func addMap(index, name, fileName, description):
	var map = {
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
func setMapButton(map, button):
	# button.get_node("Change Button").filename = map["filename"]
	button.get_node("Change Button").map = map
	button.get_node("Name").text = map.name
	button.get_node("Description").text = map.description
@export var mapVBox : Node
func updateMapsMenu():
	# var mapVBox = get_node("UpgradeShopContainer/UpgradeShop/M/ScrollContainer/VBoxContainer")
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
		

@export var GrowingManager : Node
var leaves = 0
func set_leaves():
	leaves = GrowingManager.leaves
func get_leaves():
	return GrowingManager.leaves
class Building:
	var level = 0
	var baseCost
	var cost
	var THCpS = 0.0
	var baseTHCpS = 0.0
	var THCpSWhileBurning : float = 0.0
	var baseTHCpSWhileBurning : float= 0.0
	var costExponent
	var THCpSExponent
	var name = ""
	var afterBuyFnRef
	var upgradeAdditiveMultiplier = 1.0
	var upgradeMultiplicativeMultiplier = 1.0
	var index = 0
	var samaraMult = 1.0
	# These properties are used for the progress bar, they show which level upgrade for this building
	# was bought last and at which level is the next one
	var lastUpgLv = 0
	var nextUpgLv = 1
	# buys and returns the new currency amount
	func buy(amount, currency = Globals.CURRENCIES.THC, multibuy_n : int = 1):
		var new_amount = amount
		print("chuj")
		print(Globals.CURRENCIES)
		if (currency == Globals.CURRENCIES.THC and amount >= cost) or (currency == Globals.CURRENCIES.LEAF and amount >= cost):
			new_amount = amount - cost
			print("cjuyh")
			level += 1
			recalculateCost()
			recalculateTHCpS()
			afterBuyFnRef.call()
		return new_amount
	# Adds one level to the building for free
	func addOne():
		level += 1
		recalculateCost()
		recalculateTHCpS()
		afterBuyFnRef.call()
	func recalculateCost():
		cost = snapped(baseCost + baseCost * pow(level, costExponent), 0.02)
	func recalculateTHCpS():
		THCpS = baseTHCpS * level * upgradeAdditiveMultiplier * upgradeMultiplicativeMultiplier * samaraMult
		THCpSWhileBurning = baseTHCpSWhileBurning * level * upgradeAdditiveMultiplier * upgradeMultiplicativeMultiplier * samaraMult
	func _init(_name = "",_cost = 0, _THCpS = 0, _THCpSWhileBurning = 0, afterBuyFn = "", _costExponent = 1.2, _THCpSExponent = 1, _defaultNextUpgLv = 5):
		
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
	Building.new("Zapalniczka", 0.5, 0.1, 0.0, afterBuyRef, 1.31, 5), # 0
	Building.new("Jabłko", 20, 3, 0, afterBuyRef, 1.2, 5), # 1
	Building.new("Lufka", 600, 50, 0, afterBuyRef, 1.14, 5), # 2
	Building.new("Wodospad", 160000, 7500, 0, afterBuyRef, 1.14, 5), # 4
	Building.new("Wiadro", 750000000, 30000000, 0, afterBuyRef, 1.09, 5),
	Building.new("Bongo", 750000000000000, 5000000000000, 0, afterBuyRef, 1.12),	# 7
	Building.new("Joint", 4200000000000000000000, 4000000000000000, 0, afterBuyRef, 1.12),	# 6
	Building.new("Waporyzator", 10000000000000000000000000000, 3000000000000000000000, 0.0, afterBuyRef, 1.2),	# 8
	Building.new("Dab pen",300000000000000000000000000000000000, 70000000000000000000000000.0, 0.0, afterBuyRef, 1.26),	# 9
	Building.new("Wulkan", 3000000000000000000000000000000000000.0, 405, 0, afterBuyRef, 1.2), # 10
	# Building.new("Klepsydra", 420000000, 405, 0, afterBuyRef, 1.2),
]

var nextBuildingID = 0
func afterSamara():
	recalculateTHCpS()
	updateBuildingShop()
func setSamaraNextBuilding():
	var maxBuildingID = 0
	
	for building in buildings:
		if building.level > 0:
			maxBuildingID = building.index
	var minBuildingID = max(0, maxBuildingID - 2) # max minus 2, or 0 if negative
	nextBuildingID = randi_range(minBuildingID, maxBuildingID)
	
	samaraManager.refreshBuffsText()
func getInstaBuilding():
	buildings[nextBuildingID].addOne()
	afterSamara()
	setSamaraNextBuilding()
func samaraBuildingBuff():
	buildings[nextBuildingID].samaraMult = 5.0
	buildings[nextBuildingID].recalculateTHCpS()
	afterSamara()
	setSamaraNextBuilding()
	await get_tree().create_timer(90.0).timeout
	buildings[nextBuildingID].samaraMult = 1.0
	afterSamara()
var leafTexture

func getTHC():
	return thc 


@onready var thcLabel = get_node("CanvasLayer/THC Points Label")
@onready var burnPctLabel = get_node("CanvasLayer/Percentage")
@export var burnProgressBar : TextureProgressBar
@onready var burnProgressBarSecondary = get_node("Burn Button/Burn Progress Secondary")
@export var buyShakePlayer : AnimationPlayer
func _on_BuildingBuy(index, _currency = Globals.CURRENCIES.THC):
	print("chujujujhuj")
	thc = buildings[index].buy(thc)
	buildingsVisualManager.setModelVisibility(index)
	buyShakePlayer.play("shake")
	# recalculateTHCpS()
	_on_Upg_Button_Disable_timeout()
	
func afterBuildingBuy():
	recalculateTHCpS()
	updateBuildingShop()
	updateUpgradesShop()
	
	
func makeBuildingShop():
	var button = preload("res://Scenes/BuildingButton.tscn")
	# Reset the VBox to its' initial state
	for n in buildingVBox.get_children():
		buildingVBox.remove_child(n)
		n.queue_free()
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
		currentButton.get_node("Buy Button").showCost(thcWithNumberAffix(building.cost))
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
		print("The motherfucking building VBOX")
		print(buildingVBox.get_children())
		buildingVBox.visible = true
		buildingVBox.add_child(currentButton)
		#updateBuildingShop()
		#updateUpgradesShop()
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
		currentButton.get_node("Buy Button").showCost(thcWithNumberAffix(building.cost))
		# Set the progress bar
		var progressBar = currentButton.get_node("Upgrade Progress")
		progressBar.min_value = building.lastUpgLv
		progressBar.max_value = building.nextUpgLv
		progressBar.value = building.level
		currentButton.get_node("LevelPanel/Level").text = str(building.level)
		var curBuyButton = currentButton.get_node("Buy Button")
		if !curBuyButton.is_connected("BuildingBuy", _on_BuildingBuy):
			curBuyButton.connect("BuildingBuy", _on_BuildingBuy)
		# buildingVBox.add_child(currentButton)
		updateUpgradesShop()

func shopLightSwipe():
	for building in buildingVBox.get_children():
		await get_tree().create_timer(0.2).timeout
		building.get_node("Buy Button").get_node("LightSwipe").playLightSwipe()

# Upgrades that behave like buildings
var seriesUpgradesThc = [
	# Building example: 
	# Building.new("Zapalniczka", 0.5, 0.1, 0, afterBuyRef, 1.31, 5), # 0
	Building.new("THC +15%", 20000000000000, 0, 0, afterBuyRef, 12, 1, -1),
	Building.new("THC ×1.10", 50000000000000, 0, 0, afterBuyRef, 12, 1, -1),
	Building.new("Liście +25%", 200000000000000, 0, 0, afterBuyRef, 16, 1, -1)
]
var seriesUpgradesLeaves = [
	Building.new("THC +15%", 4, 0, 0, afterBuyRef, 4, 1, -1),
	Building.new("THC ×120%", 4, 0, 0, afterBuyRef, 4, 1, -1),
	Building.new("Liście +50%", 4, 0, 0, afterBuyRef, 4, 1, -1),
	Building.new("Liście ×1.25", 4, 0, 0, afterBuyRef, 4, 1, -1)
]
var thcSeriesAddMult = 1
var thcSeriesMultMultiplicative = 1
var growingThcAddMult = 1
var growingThcMultMultiplicative = 1
func updateSeriesUpgrades():
	# Clear the children (buttons) to remake them
	for child in seriesUpgradesThcContainer.get_children():
		child.queue_free()
	for i in seriesUpgradesThc.size():
		# The "upgrade" is actually a building but without the usual effect on THCpS
		var cur_upg = seriesUpgradesThc[i]
		spawnBuildingButton(cur_upg, i, seriesUpgradesThcContainer, seriesUpgradeButton, Globals.CURRENCIES.THC)
	for i in seriesUpgradesLeaves.size():
		var cur_upg = seriesUpgradesLeaves[i]
		spawnBuildingButton(cur_upg, i, seriesUpgradesThcContainer, seriesUpgradeButton, Globals.CURRENCIES.LEAF)
	# Set the gameplay effects
	# Probabaly bad idea to code it like this but idc
	## THC upgrades
	thcSeriesAddMult = 1 + seriesUpgradesThc[0].level
	thcSeriesMultMultiplicative = pow(1.10, seriesUpgradesThc[1].level)
	GrowingManager.set_leaf_add_mult_thc_level(seriesUpgradesThc[2].level)
	## Leaf upgrades
	growingThcAddMult = 1 + seriesUpgradesLeaves[0].level * 0.15
	growingThcMultMultiplicative = pow(1.2, seriesUpgradesLeaves[1].level)
	GrowingManager.set_leaf_add_mult_leaf_level(seriesUpgradesLeaves[2].level)
	GrowingManager.set_leaf_multiplicative_mult_leaf_level(seriesUpgradesLeaves[3].level)
@export var seriesUpgradesThcContainer : VBoxContainer
@export var seriesUpgradeButton : Resource
func afterSeriesBuy():
	pass
func _on_seriesBuy(index, currency):
	if currency == Globals.CURRENCIES.THC:
		print("thc upgrade")
		thc = seriesUpgradesThc[index].buy(thc)
	elif currency == Globals.CURRENCIES.LEAF:
		# Pretty bullshit i know
		var newLeaves = seriesUpgradesLeaves[index].buy(leaves)
		GrowingManager.set_leaves(newLeaves)
		leaves = newLeaves
		
	recalculateTHCpS()
	updateSeriesUpgrades()
	

func spawnBuildingButton(building, index, container, button, currency):
	var cur_button = button.instantiate()
	cur_button.get_node("Name").text = building.name
	var buyButton = cur_button.get_node("Buy Button")
	buyButton.index = index
	buyButton.showCost(thcWithNumberAffix(building.cost))
	if currency == Globals.CURRENCIES.LEAF:
		buyButton.showCost(thcWithNumberAffix(building.cost, false) + " Liści")
		buyButton.currency = currency
	buyButton.showData(building)
	# buyButton.cost = cur_upg.cost
	buyButton.connect("BuildingBuy", _on_seriesBuy)
	container.add_child(cur_button)


# UPGRADES CODE
@export var upgradeVBox : VBoxContainer
func updateUpgradesShop():
	# var upgradeVBox = get_node("UpgradeShopContainer/UpgradeShop/U/ScrollContainer/UpgContainer/NormalUpgrades")
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
	# Code for the label that shows that there are no upgrades
	# Useless because of series upgrades
	if visibleUpgradesAmount <= 0:
		NoUpgLabel.visible = false
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
		buildings[i].recalculateTHCpS()
		THCpSWhileBurning += buildings[i].THCpSWhileBurning
		THCpS += buildings[i].THCpS
		# update_Discord()
	THCpS = THCpS * toleranceMult * globalAdditiveMultiplier * burnPercentage * samaraTHCPSbonus * thcSeriesAddMult * thcSeriesMultMultiplicative * growingThcAddMult * growingThcMultMultiplicative
@export var starting_THC : float
func _ready():
	leafTexture = load("res://Sprites/cannabis.png")
	# Starter thc lmao
	# Godmode (disabled on release build)
	print("godmode", godmode)
	if godmode:
		enableGodmode()
	if not OS.is_debug_build():
		disableGodmode()
	


	addMap(0, "Piwnica", "piwnica.jpg", "Nie jest najlepsza. ale od czegoś trzeba zacząć")
	loadGame()
	prestigeManager.recalculateToleranceMult()
	recalculateTHCpS()
	makeBuildingShop()
	updateBuildingShop()
	updateUpgradesShop()
	updateSeriesUpgrades()
	updateMapsMenu()
	refreshBuildingsList()
	if(starting_THC != 1):
		addTHC(starting_THC)
	
func refreshBuildingsList():
	var buildingListNode = get_node(buildingVBoxPath)
	buildingButtonList = []
	for i in buildingListNode.get_child_count():
		buildings[i].index = i
		var button = {"index": i, "cost": buildings[i].cost, "name": buildings[i].name}
		if thc/2 > buildings[i].cost:
			buildingButtonList.append(button)
func _process(delta):
	# Code for changing the burn percentage based on the percentage
	if isBurning:
		var added = burnPercentage + (burnPctPerSec * samaraBurnPctBonus) * delta
		burnPercentage = min(added, 1)
	else:
		var drained = burnPercentage - burnPctDrainPerSec * delta
		burnPercentage = max(burnPctMinimum, drained)
	burnChange()
	elapsedTime += delta
	THCpSToDisplay = THCpS
	addOpalanie(burnPercentage*0.01)
	addTHC(THCpS*delta)
func _on_Topek_burning(delta):
	THCpSToDisplay = THCpS + THCpSWhileBurning
	addTHC(THCpSWhileBurning * delta)

func THCpStext(THCpS):
	return "+" + "dsadsadsa" + "%" + " THCpS "

func refreshTHCpS():
	recalculateTHCpS()

func getVisualTHCCoefficient():
	return sqrt( 2 * (thc)/(99999999999999999999999999999999999999999999.0) )
@onready var burnButtonLabel = get_node("Burn Button/Pal")
func updateBurnButtonLabel():
	var thcCoefficient = getVisualTHCCoefficient()
@export var fireBox : StyleBoxTexture
func burnChange():
	refreshBurnPctLabel()
	refreshTHCpS()
	burnButton.burnPercentage = burnPercentage
	const max_haze = 0.04
	const burnThreshold = 0.6
	# Visual effects
	var thcCoefficient = getVisualTHCCoefficient()
	charPortrait.burnPercentage = burnPercentage
	charPortrait.refreshPortrait()
	worldEnvironment.get_environment().adjustment_brightness = 0.6 + max(0, burnPercentage - 0.3) * thcCoefficient
	worldEnvironment.get_environment().adjustment_contrast = 1 + max(0, burnPercentage - 0.7) * 0.6 * thcCoefficient
	worldEnvironment.get_environment().adjustment_saturation = 1 + max(0, burnPercentage - 0.85) * 1 * thcCoefficient
	fireBox.texture.speed_scale = burnPercentage * 10
	fireBox.expand_margin_bottom = burnPercentage * 6
	fireBox.expand_margin_top = burnPercentage * 6
	fireBox.expand_margin_left = burnPercentage * 6
	fireBox.expand_margin_right = burnPercentage * 6
	subViewportContainer.material.set_shader_parameter("jaranie", burnPercentage);
	# lufkaMaterial.set_shader_parameter("opalCoefficient", amount)
	burnButton.material.set_shader_parameter("uvCoeff", 50.0 + abs(burnPercentage))
	if burnPercentage > burnThreshold:
		
		var density = ( (burnPercentage - burnThreshold)/(1-burnThreshold) ) * max_haze
		# var tween = get_tree().create_tween()
		# tween.tween_property(worldEnvironment.environment, "volumetric_fog_density", density, 0.8)
		worldEnvironment.environment.fog_density = density
	else:
		# tween.tween_property(worldEnvironment.environment, "volumetric_fog_density", 0.01, 0.8)
		worldEnvironment.environment.fog_density = 0.01
	buildingsVisualManager.burnPercentage = burnPercentage
func refreshBurnPctLabel():
	burnPctLabel.text = str(burnPercentage * 100) + "%"
	burnProgressBar.value = burnPercentage * 100
	# burnProgressBarSecondary.value = (burnPercentage - 0.5) * 200
func _on_burn_press():
	pass
	# Old code for pressing the button to gain burning instead of holding the button
	# burnPercentage = min(burnPercentage + burnPctPerClick, 1)

func addTHC(amount):
	# Change the THCps label's text
	globalTHCpSLabel.text = "THCpS: " + thcWithNumberAffix(THCpS/burnPercentage) + "\n (" + thcWithNumberAffix(THCpS) + ")" + " "
	
	thcThisPrestige += godTHCmultiplier * amount
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
		if i > 1 and buildings[index - 2].level == 0: # I NEED TO CHECK IF IT IS NAN OR UNDEFINED OR SOMETHING
			buildingVBox.get_child(index).visible = false
		else:
			# Setting this fucking piece of garbage to false accidentaly gave me such a fucking headache god fucking dammit
			buildingVBox.get_child(index).visible = true
		if cost > thc:
			buildingVBox.get_child(index).get_node("Buy Button").disabled = true
		else:
			buildingVBox.get_child(index).get_node("Buy Button").disabled = false
	var upgradesNodes = upgradesScrollContainer.get_children()
	for i in upgradesNodes.size():
		var upgIndex = upgradesNodes[i].get_node("Buy Button").index
		if Upgrades.upgrades[upgIndex].cost > thc:
			upgradesNodes[i].get_node("Buy Button").disabled = true
		else:
			upgradesNodes[i].get_node("Buy Button").disabled = false
	
		


func _on_SaveTimer_timeout():
	saveGame()





@export var buildingsVisualManager2D : Node
func handle_Burn_Button_hold():
	isBurning = true
	buildingsVisualManager2D.isSmoking = true
func handle_Burn_Button_release():
	isBurning = false
	buildingsVisualManager2D.isSmoking = false

func _on_map_switcher_map_change(map):
	pass # Replace with function body.
