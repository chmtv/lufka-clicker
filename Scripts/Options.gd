extends Control

@export var musicManager : AudioStreamPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_music_volume_slider_value_changed(value):
	musicManager.setMusicVolume(value)
