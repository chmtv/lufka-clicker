extends Area3D

signal MapChangeById(map)

@export var next := true
@export var prev := false
var mapIndex = 3
func nextMap():
	emit_signal("MapChangeById", mapIndex)

func setName(name):
	get_node("Name").text = name

@onready var camera3d = get_tree().root.get_node("Node2D/Game Manager/SubViewportContainer/SubViewport/CameraMover/Camera3D")
func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		var from = camera3d.project_ray_origin(event.position)
		var to = from + camera3d.project_ray_normal(event.position) * 1000
		var space_state = get_world_3d().direct_space_state
		var ray_query = PhysicsRayQueryParameters3D.create(from, to)
		ray_query.from = from
		ray_query.to = to
		ray_query.collide_with_areas = true
		var result = space_state.intersect_ray(ray_query)
		if result and result.collider.next:
			nextMap()
		
