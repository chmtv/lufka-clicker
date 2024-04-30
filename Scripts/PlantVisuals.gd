extends Control

# Utility
var rng = RandomNumberGenerator.new()
func RandomV2(min, max):
	rng.randomize()
	return Vector2(randf_range(min.x,max.x), randf_range(min.y, max.y))

# Array of arrays of tuples of form [vec2 leafPos, float growth]
class Leaf:
	var growth = 0.1
	var subleaves = []
	var pos
	func _init(subleaves, pos = Vector2(0.5,0.7), growth = 0.1):
		self.subleaves = subleaves
		self.growth = growth
		self.pos = pos
	var rng = RandomNumberGenerator.new()
	func RandomV2(min, max):
		return Vector2(lerp(min,max, rng.randf())).normalized();
	func generateSubleaves(amountPerLeaf = 4, generations = 3):
		for j in range(1,generations):
			for i in range(1,amountPerLeaf):
				rng.randomize()
				var leafPos = Vector2(
					rng.randf_range(self.pos.x - j*0.15,self.pos.x + j*0.15),
					rng.randf_range(self.pos.y-0.3,self.pos.y-0.15),
					)
				var leafToAdd = Leaf.new([], leafPos)
				leafToAdd.generateSubleaves(amountPerLeaf, generations - 1)
				subleaves.append(leafToAdd)
	func getSubleaves():
		var result = []
		for subleaf in self.subleaves:
			result.append(subleaf)
			# result.append_array(subleaf.getAllSubleaves())
		return result
var Plant = Leaf.new([])
		

func refreshPlant():
	pass

func drawSubleafBranches(leaf):
	for subleaf in leaf.subleaves:
		pass
@export var leafTexture : Texture2D
func _draw():
	var viewport_size = get_viewport_rect().size
	draw_set_transform(Vector2.ZERO, 0.0, Vector2(10.0, 10.0))

	# Draw leaves
	#draw_texture(leafTexture, subleaf.pos)
	var connectionTuples = [[Plant, Plant.getSubleaves()]]
	for tuple in connectionTuples:
		for subleaf in tuple[1]:
			var root_pos = tuple[0].pos
			var target_pos = subleaf.pos
			target_pos.x *= viewport_size.x
			target_pos.y *= viewport_size.y
			print(root_pos, target_pos)
			draw_line(root_pos * viewport_size, target_pos, Color(0.14,0.63,0.4), 3)
			draw_texture(leafTexture, target_pos-Vector2(16,16))
			connectionTuples.append([subleaf, subleaf.getSubleaves()])
			
			
	
			
func _process(delta):
	queue_redraw()
func _ready():
	Plant.generateSubleaves()
	
	print(Plant.subleaves)
