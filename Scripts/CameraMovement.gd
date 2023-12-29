extends Node3D
var mousePressed = false
var shouldRotate = true

func _ready():
	pass

#func _process(delta):
#
#	#
#	get_node("Camera").look_at(Vector3(0,0,0), Vector3(0,1,0))
##	if mousePressed:
##			rotate(get_global_transform().basis.x, mouse_sens * delta)

var lookSensitivity = 30
var time = 0
var rotationMultiplier = 1
func _process(delta):
	time += delta
	
	var rot = Vector3(mouseDelta.y, mouseDelta.x, 0) * lookSensitivity * delta
	rotation_degrees.x += rot.x
	rotation_degrees.x = clamp(rotation_degrees.x, -75, 75)
	
	# Auto-rotate ease-in
	if shouldRotate:
		rotationMultiplier = min(rotationMultiplier + delta*7/10, 1)

	rotation_degrees.y -= rot.y
	# camera lag
	
	if shouldRotate:
		rotate(Vector3(0,1,0), rotationMultiplier * 0.5 * delta)
	get_node("Camera3D").look_at(Vector3(0,0,0), Vector3(0,1,0))
	# global_transform.origin = Vector3(0,pow(sin(time), time),0)

var mouse_sens = 0.3
var mouseDelta = Vector2(0,0)

func _input(event):
	if event is InputEventMouseMotion and Input.is_action_pressed("cameraMove"):
		shouldRotate = false
		rotationMultiplier = 0
		get_node("Rotation").start()
		mouseDelta = event.relative
	else:
		mouseDelta = Vector2(0,0)
#var mouse_sens = 1
#var camera_anglev=0
#func _input(event):
#	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
#		if event.is_pressed():
#			mousePressed = true
#		else:
#			mousePressed = false


func _on_Rotation_timeout():
	print("chmtb")
	shouldRotate = true
