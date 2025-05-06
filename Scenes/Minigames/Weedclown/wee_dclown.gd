extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_topex(8)

@export var topek : Resource
@export var topex_container : Node
func spawn_topex(amount : int):
	for i in range(0,amount):
		var top_instance = topek.instantiate()
		top_instance.position = Globals.get_rand_positive_vector2() * 300#  + Vector2(100,100)
		topex_container.add_child(top_instance)


@export var catch_area : Area2D
@export var catch_button : Button


@export var win_sound : AudioStreamPlayer
func _on_catch_button_pressed():
	gamewin_anim()
	win_sound.play()
	var topek_list = catch_area.get_overlapping_bodies()
	var result_text = "ZŁAPANE KURWA BUCHY: " + str(topek_list.size()) + " !"
	catch_button.text = "! BUCH KURWA ZŁAPANY ! \n" + result_text
	# Zatrzymaj topki
	var topex = topex_container.get_children()
	for child in topex:
		child.linear_velocity = Vector2(0,0)
		child.move_timer.stop()
	

@export var gamewin_label : Label
func gamewin_anim():
	var tween = get_tree().create_tween()
	print("chujhu wlaczaj ta kurwa animacje")
	gamewin_label.text = "BUCH ZŁAPANY !!!!!!!"
	# tween.tween_property(gamewin_label, "self_modulate:a", 0, 0.2).set_trans(Tween.TRANS_LINEAR)
	for i in range(0,15):
		tween.tween_property(gamewin_label, "modulate",Color(1,1,1,1), 0.05).set_trans(Tween.TRANS_SPRING)
		tween.tween_property(gamewin_label, "modulate",Color(0,0,0,0), 0.05).set_trans(Tween.TRANS_SPRING)


