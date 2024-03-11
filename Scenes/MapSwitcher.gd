extends Sprite3D


func nextMap():
	emit_signal("MapChange")


func _on_area_3d_input_event(camera, event, position, normal, shape_idx):
	print("spireihdf")
	if event is InputEventMouseButton:
		print("chuj")
