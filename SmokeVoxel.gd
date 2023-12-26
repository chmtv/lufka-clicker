extends FogVolume


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	# material.albedo *= rng.randf_range(2, 4)


var upVelocity = 9.8
var rng = RandomNumberGenerator.new()
var x = rng.randf_range(-3, 3)
var y = rng.randf_range(-3, 3)

# var densityFalloff = 0.1

func _process(delta):
	# material.emission = origEmission * rng.randf_range(0.7, 1.3)
	# material.density -= densityFalloff * delta
	var offset = Vector3(x,upVelocity,y) * delta
	global_translate(offset)


func _on_timer_timeout():
	queue_free()
