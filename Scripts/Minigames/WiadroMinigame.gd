extends Node3D
signal minigame_finished(score : float)

@export var debug_label : RichTextLabel
var progress_rate := 10.0
var max_progress := 70.0

var max_error := 25.0

var player_progress := 0.0
var score := 0.0
var score_rate = progress_rate / max_progress
var wiadro_progress : float = 0.0
var wiadro_running : bool = false
func startWiadro():
	wiadro_running = true
@export var swipingLabel : Resource
@export var root_node : Node3D
@export var bg : Sprite3D
var at_least_one_wiadro_done : bool = false
func endWiadro():
	wiadro_running = false
	var result_label = swipingLabel.instantiate()
	result_label.text = "Wynik: " + str(snapped(score * 100, 1)) + "%"
	root_node.get_parent().add_child(result_label)
	var tween = create_tween().tween_property(bg, "modulate", Color(0.,0.,0.,0.), 3.0).set_trans(Tween.TRANS_CUBIC)
	tween.finished.connect( func ():
		emit_signal("minigame_finished", score)
		root_node.queue_free()
	)

func getDistanceMult():
	return 1.0 - abs(player_progress - wiadro_progress) / max_error
func add_score(delta:float, mult := 1.0):
	score += score_rate * mult * delta * getDistanceMult()

@export var msg_label : RichTextLabel
func _process(delta):
	if wiadro_running:
		wiadro_progress += progress_rate * delta
		if wiadro_progress > max_progress:
			add_score(delta,-3.0)
		else:
			add_score(delta,1.0)
	
	# debug textt
	var debug_text := ""
	debug_text += "wiadro_progress: " + str(wiadro_progress) + "\n"
	debug_text += "player_progress: " + str(player_progress) + "\n"
	debug_text += "score: " + str(score)
	debug_label.text = debug_text

	if wiadro_running and getDistanceMult() > 0.8:
		msg_label.text = ""
	elif player_progress > wiadro_progress:
		msg_label.text = "[center][wave][color='green'][wave]ZA SZYBKO!"
	elif player_progress < wiadro_progress:
		msg_label.text = "[center][wave][color='green'][wave]ZA WOLNO!"
	if wiadro_progress > max_progress:
		msg_label.text = '[center][shake rate=10.0 level=3][color="red"]DYM CI UCIEKA!!!'

func _input(event):
	if event is InputEventMouseMotion and wiadro_running:
		global_position.y -= 0.06 * event.relative.y
		player_progress -= event.relative.y
	if (event is InputEventMouseButton):
		if event.is_pressed():
			startWiadro()
		if event.is_released():
			endWiadro()


func _on_update_msg_timeout():
	if getDistanceMult() > 0.8:
		msg_label.text = ""
	elif player_progress > wiadro_progress:
		msg_label.text = "[center][wave][color='green'][wave]ZA SZYBKO!"
	elif player_progress < wiadro_progress:
		msg_label.text = "[center][wave][color='green'][wave]ZA WOLNO!"
	if wiadro_progress > max_progress:
		msg_label.text = '[center][shake rate=20.0 level=5 connected=1][color="red"]DYM CI UCIEKA!!!'
