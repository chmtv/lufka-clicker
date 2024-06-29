extends CPUParticles2D

@export var deleteNodeTime : float

func _ready():
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = lifetime - 0.11
	timer.timeout.connect(queue_free)
	timer.start()
