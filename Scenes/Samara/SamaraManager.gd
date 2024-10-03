extends Control

var canSpawn : bool = true
@export var SamaraUI : Resource
@export var Samara : Resource
@onready var nextSamaraTimer = $NextSamara
@export var mainManager : Node
@export var choicesBgMaterial : Material
@export var musicManager : AudioStreamPlayer
@export var chemolMaterial : ShaderMaterial
@export var cameraMover : Node
@export var lightSwipeMaterial : Material
#var minTime = 45.0
#var maxTime = 90.0
var minTime : int = 45
var maxTime : int = 90

func _ready():
	setNextSamaraTimer()
	# Connect the choice press animations
	
	
	#get_node("Background/Choice 1").connect("pressed", func():
	
	#	get_node("	Background/Choice 1/AnimationPlayer").play("bounce")
	#	)

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

func setShaderZchemolenie(zchemolenie):
	chemolMaterial.set_shader_parameter("zchemolenie", zchemolenie)
func startChemol():
	var prevMaterial = mainManager.subViewportContainer.material
	mainManager.subViewportContainer.material = chemolMaterial
	get_tree().create_tween().tween_method(setShaderZchemolenie, 1.0, 2.0, 30);
	musicManager.chemolMusic()
	cameraMover.startChemol()
	await get_tree().create_timer(30.0).timeout
	setShaderZchemolenie(1.0)
	mainManager.subViewportContainer.material = prevMaterial
var buffs = [
	Buff.new("Fire OG", 
	"Zwiększa spalanie o [color=light_green]500%[/color] na [color=yellow]6s[/color]",
	"#ff8800",
	buffBurnPct),
	Buff.new("Amnesia", "THCpS zmwiększony o [color=light_green]120%[/color] na [color=yellow]20s[/color]", "#ece6b3", buffTHCpS),
	Buff.new("Super Silver Haze", "[color=light_green]Minuta THCpS[/color] natychmiastowo", "#0055ff", instaBank),
	Buff.new("Cheese", "[color=yellow]Zapalniczka[/color] +1", "#FFFF00", buildingAddOne),
	Buff.new("Purple Haze", "Zapalniczka THCpS zwiększony o [color=light_green]500%[/color] na [color=yellow]90s[/color]", "#A020F0", buildingBuff)
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
func chemolWarningAnimation(chemolText : RichTextLabel):
	await get_tree().create_timer(2.0).timeout
	await get_tree().create_tween().tween_property(chemolText,"visible_ratio", 1.0, 1.5).finished
	await get_tree().create_timer(1.0).timeout
	return
func setChoiceInstance(UiInstance, buff, index):
	UiInstance.get_node("Name").text = buff.name
	UiInstance.get_node("Description").text = buff.description
	UiInstance.connect("pressed", buff.callback)
	UiInstance.connect("pressed", removeMenu)
	UiInstance.self_modulate = buff.color
	UiInstance.get_node("Name").text = buff.name
	UiInstance.connect("pressed", buff.callback)
	UiInstance.connect("pressed", removeMenu)
	UiInstance.scale = Vector2(0,0)
	
	
	var viewport = get_viewport_rect()
	UiInstance.pivot_offset = Vector2(viewport.size.x/2, viewport.size.y/2.0 + UiInstance.position.y)	
	var tween : Tween = get_tree().create_tween()
	await tween.tween_property(UiInstance, "scale", Vector2(1.0,1.0), 0.6 + index*0.6).set_trans(Tween.TRANS_ELASTIC).finished
	# TODO Doesn't work for some reason
	var desc_node = UiInstance.get_node("Description")
	get_tree().create_tween().tween_property(desc_node, "visible_ratio", 1, 1.5 + index*1.2).set_trans(Tween.TRANS_LINEAR)
	UiInstance.get_node("LightSwipe").playLightSwipe()
	
func spawnMenu(isChemol : bool):
	var samaraUiInstance = SamaraUI.instantiate()

	
	curUIInstance = samaraUiInstance
	var randBuff1 = randomBuff()
	var randBuff2 = randomBuff()
	var randBuff3 = randomBuff()

	setChoiceInstance(samaraUiInstance.get_node("Background/Choice 1"), randBuff1, 0)
	setChoiceInstance(samaraUiInstance.get_node("Background/Choice 2"), randBuff2, 1)
	setChoiceInstance(samaraUiInstance.get_node("Background/Choice 3"), randBuff3, 2)
	# samaraUiInstance.get_node("Background/Choice 1/Name").text = randBuff1.name
	# samaraUiInstance.get_node("Background/Choice 1/Description").text = randBuff1.description
	# samaraUiInstance.get_node("Background/Choice 1").connect("pressed", randBuff1.callback)
	# samaraUiInstance.get_node("Background/Choice 1").connect("pressed", removeMenu)
	# samaraUiInstance.get_node("Background/Choice 1").self_modulate = randBuff1.color
	
	# samaraUiInstance.get_node("Background/Choice 2/Name").text = randBuff2.name
	# samaraUiInstance.get_node("Background/Choice 2/Description").text = randBuff2.description
	# samaraUiInstance.get_node("Background/Choice 2").connect("pressed", randBuff2.callback)
	# samaraUiInstance.get_node("Background/Choice 2").connect("pressed", removeMenu)
	# samaraUiInstance.get_node("Background/Choice 2").self_modulate = randBuff2.color
	
	# samaraUiInstance.get_node("Background/Choice 3/Name").text = randBuff3.name
	# samaraUiInstance.get_node("Background/Choice 3/Description").text = randBuff3.description
	# samaraUiInstance.get_node("Background/Choice 3").connect("pressed", randBuff3.callback)
	# samaraUiInstance.get_node("Background/Choice 3").connect("pressed", removeMenu)
	# samaraUiInstance.get_node("Background/Choice 3").self_modulate = randBuff3.color
	

		
		
	
	get_tree().root.add_child(samaraUiInstance)
	if isChemol:
		var chemolText : RichTextLabel = samaraUiInstance.get_node("Background/ChemolWarning")
		samaraUiInstance.get_node("Background/Choice 1").visible = false
		samaraUiInstance.get_node("Background/Choice 2").visible = false
		samaraUiInstance.get_node("Background/Choice 3").visible = false
		await chemolWarningAnimation(chemolText)
		await removeMenu()
		startChemol()
		samaraUiInstance.get_node("Background/Choice 1").visible = true
		samaraUiInstance.get_node("Background/Choice 2").visible = true
		samaraUiInstance.get_node("Background/Choice 3").visible = true
	else:
		samaraUiInstance.get_node("Background").material = choicesBgMaterial
		musicManager.samaraOpen()
func removeMenu():
	var aniPlayer = curUIInstance.get_node("Background/AnimationPlayer")
	await get_tree().create_timer(.5).timeout
	# $AnimationPlayer.play("bounce")
	aniPlayer.play_backwards("open")
	await get_tree().create_timer(0.5).timeout
	musicManager.samaraClose()
	await get_tree().create_timer(0.5).timeout

	mainManager.setSamaraNextBuilding()

	if is_instance_valid(curUIInstance):
		curUIInstance.queue_free()
	return
func setNextSamaraTimer():
	var randomTime = randf_range(minTime,maxTime)
	
	await get_tree().create_timer(randomTime).timeout
	_on_next_samara_timeout()

# not working
@export var chemolChance : float = 0.03
# not working
func rollForChemol():
	# Roll a 1/15 chance of giving a chemol
	var diceResult = randi_range(1,15);
	if diceResult == 1:
		return true
	return false
func pressSamara():
	var isChemol = rollForChemol()
	spawnMenu(isChemol)
	if is_instance_valid(curSamaraInstance):
		curSamaraInstance.queue_free()

func _on_next_samara_timeout():
	setNextSamaraTimer()
	var samaraInstance = Samara.instantiate()
	var randX = randf_range(0,size.x) 
	var randY = randf_range(0,size.y)
	var randRot = randf_range(0,360)
	
	samaraInstance.position = Vector2(randX, randY)
	samaraInstance.rotation = randRot
	# tween_property(worldEnvironment.environment, "volumetric_fog_density", 0.01, 0.8)
	samaraInstance.scale = Vector2(0,0)
	samaraInstance.connect("pressed", pressSamara)
	# cannot assign to a constant wtf
	# get_tree().create_timer(timeToRemoveSamara).timeout = func():
	# 	samaraInstance.queue_free()
	curSamaraInstance = samaraInstance
	add_child(samaraInstance)
	var scaleTween = get_tree().create_tween().tween_property(samaraInstance,"scale", Vector2(1.0,1.0), 5).set_trans(Tween.TRANS_ELASTIC)
	var samaraToRemove = curSamaraInstance
	var timeToRemoveSamara = (maxTime - minTime) / 2
	await get_tree().create_timer(timeToRemoveSamara).timeout
	if is_instance_valid(samaraToRemove):
		samaraToRemove.queue_free()

