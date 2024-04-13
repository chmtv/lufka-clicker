extends Node

@onready var upgradeShop = get_parent().get_node("UpgradeShopContainer")
@onready var animationPlayer = get_node("AnimationPlayer")
# @onready var parentNode = get_parent().get
var menuOpen = false

var posYOpen = 0
var posYClosed = 500
var posYCurrent = 30
var time = 0
var countingTime = false
@export var musicManager : AudioStreamPlayer

func _physics_(delta):
	if countingTime:
		time += delta * 50
	var viewport = get_viewport().size
	if menuOpen:
		# Open menu
		print("menu opened")
		#upgradeShop.position = upgradeShop.position.move_toward(Vector2(0, posYOpen + 50), time)
		# vvv JA PO PROSTU KURWA NIE WIEM CO TU SIE KURWA STAŁO
		# parentNode.position = parentNode.position.move_toward(Vector2(viewport.x - size.x, posYOpen - verticalOffset / 2), time)
		upgradeShop.position = upgradeShop.position.move_toward(Vector2(upgradeShop.position.x, 64), time)
		if upgradeShop.position.y <= posYOpen:
			time = 0
			countingTime = false
	else:
		# Close menu
		#upgradeShop.position = upgradeShop.position.move_toward(Vector2(0, posYClosed + 30000), time)
		# vvv TY KURWA CO JEST 10 KURWA
		upgradeShop.position = upgradeShop.position.move_toward(Vector2(upgradeShop.position.x, posYClosed), time)
		if upgradeShop.position.y >= posYClosed:
			time = 0
			countingTime = false
	


@onready var menuOpenPlayer : AudioStreamPlayer = get_node("Menu Open")
@onready var menuClosePlayer : AudioStreamPlayer = get_node("Menu Close")
func _on_shop_close_pressed():
	animationPlayer.play_backwards("shopSlide")
	menuClosePlayer.play()
	musicManager.shopClose()
	
func _on_shop_open_pressed():
	menuOpenPlayer.play()
	animationPlayer.play("shopSlide")
	musicManager.shopOpen()
