extends Control

@export var tip_label : Label
@export var progress_label : Label
@export var tips : Array[String]

var path = "res://Scenes/Game.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	ResourceLoader.load_threaded_request(path)
	tip_label.text = tips.pick_random()

func _process(delta):
	var progress = []
	var status = ResourceLoader.load_threaded_get_status(path, progress)
	if status == ResourceLoader.THREAD_LOAD_LOADED:
		var loaded_game : Resource = ResourceLoader.load_threaded_get(path)
		add_child(loaded_game.instantiate())
	if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		var status_str = str(snapped(progress[0] * 100,1)) + "%"
		progress_label.text = status_str
