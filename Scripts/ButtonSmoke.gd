extends Panel

const animLength = 0.6
@export var burnDownShaderMaterial : ShaderMaterial
@onready var burnTimer = get_tree().create_timer(animLength)

func setFireZoom(zoom):
	burnDownShaderMaterial.set_shader_parameter("zoom", zoom)
func buyAnimation():
	var prevMaterial = material
	material = burnDownShaderMaterial
	
	var startTween = create_tween().tween_method(setFireZoom,0.0,2.5,animLength/2.0).set_trans(Tween.TRANS_LINEAR)
	await startTween.finished
	create_tween().tween_method(setFireZoom,2.5,0.0,animLength).set_trans(Tween.TRANS_QUAD)
	# For some reason it breaks the position of the button,
	# possibly because of some code in the building button refresher, idk
	# $AnimationPlayer.play("cardMove")
	burnTimer.time_left = animLength
	await burnTimer.timeout
	# material = null
