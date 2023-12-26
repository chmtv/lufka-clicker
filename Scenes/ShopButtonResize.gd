extends Control

func _ready():
	get_tree().root.connect("size_changed", Callable(self, "_on_viewport_size_changed"))
	_on_viewport_size_changed()
func _on_viewport_size_changed():
	custom_minimum_size = Vector2(get_viewport_rect().end.x,50)
	
