extends AudioStreamPlayer

@export var musicStreams : Array[AudioStream]

func setPitchScale(pitch):
	create_tween().tween_property(self, "pitch_scale", pitch, 0.5).set_trans(Tween.TRANS_EXPO)
func setMusicVolume(db):
	volume_db = db
func changeBus(name : String):
	if not onChemol:
		bus = name


var onChemol : bool = false
func shopOpen():
	setPitchScale(0.95)
	changeBus("Shop")
func shopClose():
	setPitchScale(1.0)
	changeBus("Master")
func samaraOpen():
	setPitchScale(0.8)
	changeBus("Samara")
func samaraClose():
	setPitchScale(1.0)
	changeBus("Master")
func chemolMusic():
	changeBus("Chemol")
	onChemol = true
	var masterBusID = AudioServer.get_bus_index("Chemol")
	var distortionEff = AudioServer.get_bus_effect(masterBusID,0)
	create_tween().tween_method(setPitchScale, 1.0, 1.2, 30)
	await create_tween().tween_property(distortionEff, "drive", 0.6, 15).finished
	distortionEff.drive = 0
	onChemol = false
	setPitchScale(1.0)
	changeBus("Master")
func growingMusic():
	changeBus("Growing")
	setPitchScale(0.8)
func getRandomTrack():
	return musicStreams[randi() % musicStreams.size()]
@export var buildingsVisualManager : Node
func changeMusic():
	# stream = getRandomTrack()
	buildingsVisualManager.next_minor_beat = 0
	buildingsVisualManager.next_major_beat = 0
	buildingsVisualManager.next_rotation_beat = 0
	buildingsVisualManager.rotationSpeed = 0.6
	stream = musicStreams[5]
	play()
	seek(0)

func _ready():
	get_tree().create_timer(1.0).timeout.connect(changeMusic)


func _on_finished():
	changeMusic()
