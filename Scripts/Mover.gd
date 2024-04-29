extends Control

@export var jaranie : Node
@export var growing : Panel
@export var nodesToMove : Array[Node]
@export var musicManager : AudioStreamPlayer
var growingShown := false

func changeGamemode(gamemode):
	var moveTo = Vector2(0,0)
	const offset = 108*1.7
	match gamemode:
		0:
			moveTo = Vector2(0,0)
		1: 
			print("gm 1")
			moveTo = Vector2(offset,0)
	for node in nodesToMove:
		# get_tree().create_tween().tween_property(node,"position", moveTo, 2.0)
		node.position += moveTo

# This one is for toggling the growing but I'm too lazy to change it now and reconnect the signal
func setGamemodeGrowing():
	if growingShown == true:
		get_tree().create_tween().tween_property(growing,"position", Vector2(-get_viewport_rect().size.x,0), .7).set_trans(Tween.TRANS_ELASTIC)
		musicManager.shopClose()
		growingShown = false
	else:
		get_tree().create_tween().tween_property(growing,"position", Vector2(0,0), .7).set_trans(Tween.TRANS_ELASTIC)
		musicManager.growingMusic()
		growingShown = true
