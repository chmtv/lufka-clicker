extends Control

@export var animPlayer : AnimationPlayer
var menuOpen = false

func handleButtonPress():
	if menuOpen:
		animPlayer.play_backwards("shopSlide")
		menuOpen = false
	else:
		animPlayer.play("shopSlide")
		menuOpen = true
