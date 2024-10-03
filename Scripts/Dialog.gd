extends Control

@export var label : RichTextLabel

@export var closeButton : Button
@export var canClose : bool

func setText(text):
	label.text = text

func setCloseButton():
	if canClose:
		closeButton.set_process(true)
	else:
		closeButton.set_process(false)

func closeDialog():
	var x = position.x
	var pos_tween = create_tween().tween_property(self, "position", Vector2(x, 300),1).set_trans(Tween.TRANS_BACK)
	await pos_tween.finished
	queue_free()
func _ready():
	closeButton.connect("pressed", closeDialog)
	setCloseButton()
