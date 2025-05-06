extends RigidBody2D

@onready var tween = get_tree().create_tween()
func _on_move_timer_timeout():
	begin_stop()
	var rand_time = randf_range(0.5,2)
	move_timer.wait_time = stop_timer.wait_time + rand_time
	var rand_offset = Globals.get_random_vector2()
	var speed = 250
	linear_velocity = rand_offset * speed
	
	# tween.tween_property(self, "position", target, 1)

@export var stop_timer : Timer
@export var move_timer : Timer
func begin_stop():
	stop_timer.wait_time = randf_range(0.5,1.)
	# move_timer.stop()
	stop_timer.start()

func _on_stop_timer_timeout():
	linear_velocity = Vector2(0,0)

var elapsed_time = 0.0
@export var topek_sprite : Sprite2D
func _process(delta):
	elapsed_time += delta
	var y_offset = sin(elapsed_time * 5.0) / 4.0
	topek_sprite.offset.y += y_offset
