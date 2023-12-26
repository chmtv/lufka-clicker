extends SubViewport

func _ready():
	get_tree().root.connect("size_changed", Callable(self, "_on_viewport_size_changed"))
	_on_viewport_size_changed()
func _on_viewport_size_changed():
	# size_2d_override = Vector2i(get_viewport().x,50)
