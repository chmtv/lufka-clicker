extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

@export var minigame_viewport : SubViewport
@export var minigame_viewportcontainer : SubViewportContainer
@export var wiadro_minigame_scene : Resource
@export var minigame_camera : Camera3D
func start_wiadro_minigame():
	# A lot of this code will probabaly have to be rewritten when I add more skills and minigames
	# BTW this thing is now directly connected to the wiadro button
	# First the background gets made visible
	minigame_viewportcontainer.visible = true
	var wiadro_minigame_instance = wiadro_minigame_scene.instantiate()
	wiadro_minigame_instance.position = minigame_camera.position
	wiadro_minigame_instance.position.z -= 15 # So that the camera isn't inside it
	wiadro_minigame_instance.position.y -= 7 # Height
	wiadro_minigame_instance.get_node("Wiadro2/wiadro/Circle_002").connect("minigame_finished", end_wiadro_minigame)
	minigame_viewport.add_child(wiadro_minigame_instance)

@export var mainManager : Node3D
func end_wiadro_minigame(score : float):
	# For now I won't need this
	minigame_viewportcontainer.visible = false
	mainManager.instaBank(5 * score)
