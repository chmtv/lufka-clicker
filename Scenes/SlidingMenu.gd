extends Control

@export var animPlayer : AnimationPlayer
var menuOpen = false

func handleButtonPress():
	if menuOpen:
		#animPlayer.play_backwards("shopSlide")
		get_tree().create_tween().tween_property(self, "position", Vector2(0,500), 0.7).set_trans(Tween.TRANS_ELASTIC)
		menuOpen = false
	else:
		#animPlayer.play("shopSlide")
		get_tree().create_tween().tween_property(self, "position", Vector2(0,44), 0.7).set_trans(Tween.TRANS_ELASTIC)
		menuOpen = true
