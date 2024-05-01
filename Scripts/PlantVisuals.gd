extends Control

var isWatered := true

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
	func generateSubleaves(amountPerLeaf = 2, generations = 4):
		self.subleaves = []
		for j in range(1,generations):
			var leafPos = Vector2(
					rng.randf_range(self.pos.x - j*0.1,self.pos.x + j*0.1),
					rng.randf_range(self.pos.y,self.pos.y-0.25),
					)
			var rootStemLeaf = Leaf.new([], leafPos)
			self.subleaves.append(rootStemLeaf)
			for i in range(1,amountPerLeaf):
				rng.randomize()
				leafPos = Vector2(
					rng.randf_range(self.pos.x - i*0.25,self.pos.x + i*0.25),
					rng.randf_range(self.pos.y,self.pos.y-0.25),
					)
				var leafToAdd = Leaf.new([rootStemLeaf], leafPos)
				leafToAdd.generateSubleaves(amountPerLeaf, generations - 1)
				self.subleaves.append(leafToAdd)
	func getSubleaves():
		var result = []
		for subleaf in self.subleaves:
			result.append(subleaf)
			# result.append_array(subleaf.getAllSubleaves())
		return result
var Plant = Leaf.new([])
		
func getPhaseLevel(phs):
	return int(snapped(fmod(min(phs, 2100) / 500, 4), 1))
func refreshPlant(phs : float):
	# phs is a 0-2000 float
	print("jebany phs to:", phs)
	var leafs = 3 if phs > 1500 else 2
	var generations = 1 + getPhaseLevel(phs)
	print(getPhaseLevel(phs))
	
	Plant.generateSubleaves(leafs, generations)
	print(generations, leafs, "gowno chuj jebac")
	queue_redraw()
func drawSubleafBranches(leaf):
	for subleaf in leaf.subleaves:
		pass
@export var leafTexture : Texture2D
func _draw():
	var viewport_size = get_rect().size
	# draw_set_transform(Vector2.ZERO, 0.0, Vector2(10.0, 10.0))

	# Draw leaves
	#draw_texture(leafTexture, subleaf.pos)
	var connectionTuples = [[Plant, Plant.getSubleaves()]]
	for tuple in connectionTuples:
		for subleaf in tuple[1]:
			var root_pos = tuple[0].pos
			var target_pos = subleaf.pos
			target_pos.x *= viewport_size.x
			target_pos.y *= viewport_size.y
			draw_line(root_pos * viewport_size, target_pos, Color(0.14,0.63,0.4), 3)
			# draw_line(Vector2(0,0), Vector2(10,10), Color(1,1,1), 5)
			draw_texture(leafTexture, target_pos-Vector2(16,16))
			connectionTuples.append([subleaf, subleaf.getSubleaves()])
			
			
	
			
func _process(delta):
	pass
func _ready():
	Plant.generateSubleaves()
	
	print(Plant.subleaves)
