extends Sprite2D

var move_to : Vector2
var rng : RandomNumberGenerator = RandomNumberGenerator.new()
@export var anim_tree : AnimationTree
@onready var anim_statemachine : AnimationNodeStateMachinePlayback
@export var movement_speed : float = 20

func randVector2(min_x, min_y, max_x, max_y):
	return Vector2(rng.randf_range(min_x, max_x), rng.randf_range(min_y, max_y))

func _ready():
	anim_statemachine = anim_tree.get("parameters/playback")
	var parent : Panel = get_parent()
	position = randVector2(0, 0, 144, 250)
	_on_random_movement_timeout()
	


func rand_move_target_nearby():
	var rand_offset = randVector2(-100,-100,100,100)
	var target : Vector2 = position + rand_offset
	return target
func _on_random_movement_timeout():
	move_to = rand_move_target_nearby()

func _physics_process(delta):
	move_step(delta)

func move_step(delta):
	var new_position = position.move_toward(move_to, delta * movement_speed)
	var pos_diff = new_position - move_to
	if abs(pos_diff.x) > 1 and abs(pos_diff.y) > 1:
		anim_statemachine.travel("walk")
	else:
		anim_statemachine.travel("idle")
	position = new_position


func _on_despawn_timeout():
	queue_free()
