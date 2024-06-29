extends Control

const saveFilePath = "user://lufkaClicker.sav"


func spawnWeedExplosion(pos = Vector2(-1, -1)):
	var weedExplosion = preload("res://Scenes/Particles/weedExplosion.tscn").instantiate()
	if pos == Vector2(-1, -1):
		weedExplosion.position = get_global_mouse_position()
	else:
		weedExplosion.position = pos
	get_tree().root.add_child(weedExplosion)

enum CURRENCIES {
	THC,
	LEAF
}