extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


@export var audioStreamPlayer : AudioStreamPlayer
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = "Audio sec: " + str(snapped(audioStreamPlayer.get_playback_position(), 0.01))
