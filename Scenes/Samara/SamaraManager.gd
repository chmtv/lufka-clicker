extends Control

var canSpawn : bool = true
@export var SamaraUI : Resource
@export var Samara : Resource
@onready var nextSamaraTimer = $NextSamara
@export var mainManager : Node
var minTime = 45.0
var maxTime = 90.0

func _ready():
	setNextSamaraTimer()

class Buff:
	var name := ""
	var description := ""
	var callback
	var color = ""
	func _init(_name, _description, _color, _callback):
		name = _name
		description = _description
		callback = _callback
		color = _color
func buffTHCpS():
	mainManager.samaraTHCPSbonus = 1.2
	$THCpSBuff.start()
	mainManager.afterSamara()
func _on_th_cp_s_buff_timeout():
	mainManager.samaraTHCPSbonus = 1.0
func buffBurnPct():
	mainManager.samaraBurnPctBonus = 5.0
	$BurnPctBuff.start()
func _on_burn_pct_buff_timeout():
	mainManager.samaraBurnPctBonus = 1.0
func instaBank():
	mainManager.instaBank()
func buildingAddOne():
	mainManager.getInstaBuilding()
func buildingBuff():
	mainManager.samaraBuildingBuff()

var buffs = [
	Buff.new("Fire OG", 
	"Zwiększa spalanie o [color=light_green]500%[/color] na [color=yellow]6s[/color]",
	"#ff8800",
	buffBurnPct),
	Buff.new("Amnesia", "THCpS zmwiększony o [color=light_green]120%[/color] na [color=yellow]20s[/color]", "#ece6b3", buffTHCpS),
	Buff.new("Super Silver Haze", "[color=light_green]15% THCpS[/color] natychmiastowo", "#0055ff", instaBank),
	Buff.new("Cheese", "[color=yellow]???[/color] +1", "#FFFF00", buildingAddOne),
	Buff.new("Purple Haze", "??? THCpS zwiększony o [color=light_green]500%[/color] na [color=yellow]15s[/color]", "#A020F0", buildingBuff)
]
func refreshBuffsText():
	# Set the insta-building
	buffs[3].description = "[color=yellow]"+ mainManager.buildings[mainManager.nextBuildingID].name +"[/color] +1"
	# Specific building buff
	buffs[4].description = mainManager.buildings[mainManager.nextBuildingID].name+" THCpS zwiększony o [color=light_green]500%[/color] na [color=yellow]15s[/color]"

func randomBuff():
	var randBuff = buffs[randi() % buffs.size()]
	return randBuff

var curUIInstance
var curSamaraInstance
func spawnMenu():
	var samaraUiInstance = SamaraUI.instantiate()
	curUIInstance = samaraUiInstance
	var randBuff1 = randomBuff()
	var randBuff2 = randomBuff()
	var randBuff3 = randomBuff()
	samaraUiInstance.get_node("Background/Choice 1/Name").text = randBuff1.name
	samaraUiInstance.get_node("Background/Choice 1/Description").text = randBuff1.description
	samaraUiInstance.get_node("Background/Choice 1").connect("pressed", randBuff1.callback)
	samaraUiInstance.get_node("Background/Choice 1").connect("pressed", removeMenu)
	samaraUiInstance.get_node("Background/Choice 1").self_modulate = randBuff1.color
	
	samaraUiInstance.get_node("Background/Choice 2/Name").text = randBuff2.name
	samaraUiInstance.get_node("Background/Choice 2/Description").text = randBuff2.description
	samaraUiInstance.get_node("Background/Choice 2").connect("pressed", randBuff2.callback)
	samaraUiInstance.get_node("Background/Choice 2").connect("pressed", removeMenu)
	samaraUiInstance.get_node("Background/Choice 2").self_modulate = randBuff2.color
	
	samaraUiInstance.get_node("Background/Choice 3/Name").text = randBuff3.name
	samaraUiInstance.get_node("Background/Choice 3/Description").text = randBuff3.description
	samaraUiInstance.get_node("Background/Choice 3").connect("pressed", randBuff3.callback)
	samaraUiInstance.get_node("Background/Choice 3").connect("pressed", removeMenu)
	samaraUiInstance.get_node("Background/Choice 3").self_modulate = randBuff3.color
	
	get_tree().root.add_child(samaraUiInstance)
func removeMenu():
	curUIInstance.get_node("Background/AnimationPlayer").play_backwards("open")
	await get_tree().create_timer(1.0).timeout
	if is_instance_valid(curUIInstance):
		curUIInstance.queue_free()

func setNextSamaraTimer():
	var randomTime = randf_range(minTime,maxTime)
	await get_tree().create_timer(randomTime).timeout
	_on_next_samara_timeout()

func pressSamara():
	spawnMenu()
	curSamaraInstance.queue_free()

func _on_next_samara_timeout():
	setNextSamaraTimer()
	var samaraInstance = Samara.instantiate()
	var randX = randf_range(0,size.x) 
	var randY = randf_range(0,size.y)
	var randRot = randf_range(0,360)
	samaraInstance.position = Vector2(randX, randY)
	samaraInstance.rotation = randRot
	samaraInstance.connect("pressed", pressSamara)
	curSamaraInstance = samaraInstance
	add_child(samaraInstance)




