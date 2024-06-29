extends Node2D

@export var smokeManager : Node
var isSmoking = true

var positionTimer : SceneTreeTimer
# Called when the node enters the scene tree for the first time.
func _ready():
	position = get_viewport_rect().size / 2
	positionTimer = get_tree().create_timer(999999999)
func _on_viewport_size_changed():
	position = get_viewport_rect().size / 2
var modelVisibilities = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
func setModelVisibility(index):
	modelVisibilities[index] = true
	refreshModelVisibilities()
func refreshModelVisibilities():
	var total = 0
	for i in range(0,modelVisibilities.size()):
		if i < children.size():
			children[i].visible = modelVisibilities[i]
			total = total + 1
	setPositions(total)

const smokeOffsets = [
	Vector2(0, 10), # Jablko
	Vector2(-11,0), # Lufka
	Vector2(0,16), # Wodospad
	Vector2(-1,4), # Wiadro
	Vector2(-14, 0), # Bonio
	Vector2(5,11), # Wapo
]

var dist = 80
func setPositions(amount):
	if amount > children.size():
		return
	for i in range(0,amount):
		var angle = 0
		if i > 0:
			angle = PI/3*i
		var sine = sin(angle)
		var cosine = cos(angle)
		var offset_dist = dist + sin(positionTimer.time_left * 2.8) * 10
		var pos = Vector2(sine, cosine) * dist
		pos = pos.rotated(rot)
		children[i].position = pos

func buildingSmoke(delta):
	for i in range(0, children.size()):
		var child = children[i]
		var viewport = get_viewport_rect().size
		var smoke_pos = viewport/2 + child.position - smokeOffsets[i] * child.scale
		smoke_pos.y += 0
		
		var smoke_dens = randf_range(25, 50)
		smokeManager.addSmoke(smoke_pos, smoke_dens * delta)

@onready var children = get_children()
@export var rotationSpeed : float = 0.8
var rot = 0
@onready var start_position = position
func _process(delta):
	setPositions(6)
	# Main movement (rotation)
	rot += rotationSpeed * delta
	# This fucking sucks actually VVV
	# position.y = start_position.y + sin(positionTimer.time_left * 2.8) * 18
	buildingSmoke(delta)
	if isSmoking:	
		smokeManager.isMousePressed = true
	# Shit optimization down here:
	else:
		smokeManager.isMousePressed = false
