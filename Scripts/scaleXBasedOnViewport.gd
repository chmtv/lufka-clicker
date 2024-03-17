extends TextureProgressBar

@onready var prevViewport = get_viewport_rect()

# This script is currently made to be used only on the burn progress bar
# Worst fucking piece of UI I made in a long time, I hate it
# I fucking hate bars visual bars of any kind to be honest, fuck these
# things
func _ready():
	get_tree().root.connect("size_changed", Callable(self, "_on_viewport_size_changed"))
	_on_viewport_size_changed()
	setScale()
func _on_viewport_size_changed():
	setScale()
func process(delta):
	setScale()

func setScale():
	var curViewport = get_viewport_rect()
	var x = curViewport.size.x / prevViewport.size.x
	# var y = curViewport.size.y / prevViewport.size.y
	set_deferred("size.x", curViewport.size.x/1.6)
	
	scale = Vector2(x,scale.y)
