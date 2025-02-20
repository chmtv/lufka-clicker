extends Control

const saveFilePath = "user://lufkaClicker.sav"


func spawnWeedExplosion(pos = Vector2(-1, -1)):
	var weedExplosion = preload("res://Scenes/Particles/weedExplosion.tscn").instantiate()
	if pos == Vector2(-1, -1):
		weedExplosion.position = get_global_mouse_position()
	else:
		weedExplosion.position = pos
	get_tree().root.add_child(weedExplosion)
func spawnWarning(pos = Vector2(50, 70)):
	var warningScene = preload("res://Scenes/WarningIcon.tscn").instantiate()
	warningScene.position = pos
	get_tree().root.add_child(warningScene)
func float_to_pct_str(number : float):
	return str(number * 100) + "%"
enum CURRENCIES {
	THC,
	LEAF
}
