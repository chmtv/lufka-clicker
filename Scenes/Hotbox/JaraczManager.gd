extends Panel

var jaracz_count : int = 0
@export var canSpawn : bool

@export var jaracz : Resource
func spawn_jaracz():
	jaracz_count += 1
	var new_jaracz = jaracz.instantiate()
	add_child(new_jaracz)

func _on_jaracz_spawn_timeout():
	if canSpawn:
		spawn_jaracz()
