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
func seconds_to_time_str(seconds : float):
	var days: int = int(seconds) / 86400
	var hours: int = (int(seconds) % 86400) / 3600
	var minutes: int = (int(seconds) % 3600) / 60
	var secs: int = int(seconds) % 60

	var formatted_string: String = ""

	if days > 0:
		formatted_string += "%dd " % days
	if hours > 0:
		formatted_string += "%dh " % hours
	if minutes > 0:
		formatted_string += "%dmin " % minutes
	if secs > 0 or formatted_string == "":
		formatted_string += "%ds" % secs

	return formatted_string.strip_edges()
enum CURRENCIES {
	THC,
	LEAF
}

func get_random_vector2() -> Vector2:
	var random_x = randf_range(-1, 1)
	var random_y = randf_range(-1, 1)
	return Vector2(random_x, random_y).normalized()
func get_rand_positive_vector2() -> Vector2:
	var random_x = randf_range(0, 1)
	var random_y = randf_range(0, 1)
	return Vector2(random_x, random_y)
