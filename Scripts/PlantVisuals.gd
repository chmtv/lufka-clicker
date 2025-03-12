extends Control

var isWatered := true
func makePlantThirsty():
	create_tween().tween_property(self, "modulate", Color(0.6,0.5,0.16,1), 2.0)
func rehydratePlant():
	create_tween().tween_property(self, "modulate", Color(1,1,1,1), 2.0)


# Utility
# var rng = RandomNumberGenerator.new()
func RandomV2(min, max, seed = randi()):
	# rng.state = seed
	var x = randf_range(min.x,max.x)
	# rng.state = seed + 1
	var y = randf_range(min.y, max.y)
	return Vector2(x, y)

func randomNumber(seed):
	seed ^= seed << 13
	seed ^= seed >> 17
	seed ^= seed << 5
	return seed

# Array of arrays of tuples of form [vec2 leafPos, float growth]

class Leaf:
	var growth = 0.0
	var subleaves = []
	var pos
	var rngSeed
	var rng
	var parent_index : int
	var initialRngState
	var parentPos : Vector2
	var growth_pos_offset : Vector2 = Vector2(0,0)
	var prev_leaf : Leaf
	func _init(subleaves, pos, parentLeafPos : Vector2, rngSeed = rng.randi(), growth = 0.0):
		self.subleaves = subleaves
		self.growth = growth
		self.pos = pos
		self.rngSeed = rngSeed
		self.rng = RandomNumberGenerator.new()
		self.rng.state = rngSeed
		self.initialRngState = rngSeed
		self.parentPos = parentLeafPos
		# self.parentIndex = parentIndex
	
	func resetRng():
		var seed = randi()
		self.initialRngState = seed
		self.rng.state = seed
	func RandomV2(min, max):
		return Vector2(lerp(min,max, self.rng.randf())).normalized();
	func generateSubleavesOld(amountPerLeaf = 3, generations = 4):
		self.rng.state = self.initialRngState
		self.subleaves = []
		for j in range(1,generations):
			# var rootStemLeaf = Leaf.new([], leafPos, self.rngSeed)
			# self.subleaves.append(rootStemLeaf)
			for i in range(1,amountPerLeaf):
				self.rng.state += int(pos.x*1000000)
				var posx = self.rng.randf_range(self.pos.x - 0.2,self.pos.x + 0.2)
				self.rng.state += int(pos.y*100)
				var posy = self.rng.randf_range(self.pos.y,self.pos.y-0.25)
				var leafPos = Vector2(
					posx,
					posy,
					)
				var leafToAdd = Leaf.new([], leafPos, pos, self.rng.state)
				self.subleaves.append(leafToAdd)
				leafToAdd.generateSubleaves(amountPerLeaf, generations - 1)
	func generateSubleaves(height : int = 3, leavesPerLayer : int = 4, decayPerLayer : int = 1):
		# I'm going fucking insane trying to make this bullshit work
		# It's gonna be so worth it though
		# Just imagine being stoned out of existence and looking at the fucking plant grow (fucking properly for once)
		self.rng.state = self.initialRngState
		self.subleaves = []
		var main_leaf : Leaf = self
		for layer_index in range(0, height):
			self.rng.state += int(pos.x*1000000)
			var main_x = self.rng.randf_range(0.45,0.55)
			self.rng.state += int(pos.y*100)
			var main_y = self.rng.randf_range(0.7-(layer_index+1) * 0.1, 0.7-(layer_index+1) * 0.15)
			var main_leaf_pos = Vector2(main_x, main_y)
			var new_main_leaf = Leaf.new([], main_leaf_pos, pos, self.rng.state)
			main_leaf.subleaves.append(new_main_leaf)
			new_main_leaf.prev_leaf = main_leaf
			main_leaf = new_main_leaf
			var prev_left : Leaf = new_main_leaf
			var prev_right : Leaf = new_main_leaf
			for layer_subleaf_index in range(0, leavesPerLayer - layer_index*decayPerLayer):
				# Left leaf
				self.rng.state += int(pos.x*1000000)
				var left_leaf_x = self.rng.randf_range(main_leaf_pos.x + (layer_subleaf_index+1) * -0.15, main_leaf_pos.x + (layer_subleaf_index+1) * -0.1)
				self.rng.state += int(pos.y*100)
				var left_leaf_y = self.rng.randf_range(0.7-(layer_index+1) * 0.1, 0.7-(layer_index+1) * 0.15)
				var left_leaf_pos = Vector2(left_leaf_x, left_leaf_y)
				var left_leaf = Leaf.new([], left_leaf_pos, pos, self.rng.state)
				# Right leaf
				self.rng.state += int(pos.y*1000000)
				var right_leaf_x = self.rng.randf_range(main_leaf_pos.x + (layer_subleaf_index+1) * 0.1, main_leaf_pos.x + (layer_subleaf_index+1) * 0.15)
				self.rng.state += int(pos.x*100)
				var right_leaf_y = self.rng.randf_range(0.7-(layer_index+1) * 0.1, 0.7-(layer_index+1) * 0.15)
				var right_leaf_pos = Vector2(right_leaf_x, right_leaf_y)
				var right_leaf = Leaf.new([], right_leaf_pos, pos, self.rng.state)
				prev_left.subleaves.append(left_leaf)
				prev_right.subleaves.append(right_leaf)
				left_leaf.prev_leaf = prev_left
				right_leaf.prev_leaf = prev_right
				prev_left = left_leaf
				prev_right = right_leaf
			
		# for i in range(0,main_leaves.size()-1):
			#main_leaves[i].subleaves = []
			#main_leaves[i].subleaves.append(main_leaves[i+1])
	func getSubleaves():
		# i honestly dont know why its coded this way
		# but i'm scared to change it to a return self.subleaves ;(((
		var result = []
		for subleaf in self.subleaves:
			result.append(subleaf)
			# result.append_array(subleaf.getAllSubleaves())
		return result
	func getAllSubleaves():
		var allLeaves = self.getSubleaves()
		var i = 0
		for leaf in allLeaves:
			var subleaves = leaf.getSubleaves()
			allLeaves.append_array(subleaves)
		return allLeaves

		
func getPhaseLevel(phs):
	return int(snapped(fmod(min(phs, 2100) / 500, 4), 1))
func getGenerationsForPhs(phs : float):
	return 1 + getPhaseLevel(phs)
	
var prevPhs = -1
func refreshPlant(phs : float):
	# phs is a 0-2000 float
	if not Plant:
		return
	if prevPhs > phs:
		Plant.resetRng()
	var phsRatio = phs / 2000
	var leavesToCheck = Plant.getAllSubleaves()
	# Set the leaves' growth value
	var totalGrowth = phsRatio * 19 / 3
	for i in range(0,leavesToCheck.size() - 2, 3):
		var growth : float = max( min(1, totalGrowth), 0)# Choose totalGrowth but bounded by 0 and 1 (I fucking hate the word bounded), uhhhh wtf
		totalGrowth -= growth
		leavesToCheck[i].growth = growth
		leavesToCheck[i+1].growth = growth
		leavesToCheck[i+2].growth = growth
		# i is values 0-19
		# phs is values 0-2000



	prevPhs = phs
	queue_redraw()
func regeneratePlant(phs : float):
	# phs is a 0-2000 float
	if not Plant:
		return
	var leafs = 4 if phs > 1500 else 3
	var generations = getGenerationsForPhs(phs)
	
	
	Plant.generateSubleaves(generations, leafs)
	refreshPlant(phs)
	queue_redraw()


@export var leafTexture : Texture2D
@export var doniczkaTexture : Texture2D
@export var curvePointsAmount : int = 5
const ledTint = Color(0.46,0,1.0,1.0)
const stemColor = Color(0.14,0.63,0.4,1.0)
var lightCoeff = 0.0;

func _draw():
	var plant_area = get_rect().size
	# I have no idea what the fuck is this code in the comment:
	# draw_set_transform(Vector2.ZERO, 0.0, Vector2(10.0, 10.0))
	var _drawColor = Color(1,1,1,1) + Color(1,1,1,1).lerp(ledTint, lightCoeff)
	var connectionTuples = [[Plant, Plant.getSubleaves()]]
	for tuple in connectionTuples:
		# var tuple = connectionTuples[i]
		for subleaf in tuple[1]:
			var growth = subleaf.growth
			if growth == 0:
				continue
			var target_pos = subleaf.pos
			# TODO IMPORTANT
			# This fucker needs to be lerped by the growth of the previous leaf, that's gonna take some work but it needs to be done
			var root_pos : Vector2 = tuple[0].pos

			# This shit is pretty useless ig
			# if tuple[0].prev_leaf:
				#root_pos = tuple[0].prev_leaf.pos.lerp(root_pos, tuple[0].prev_leaf.growth)
			
			
			target_pos = root_pos.lerp(target_pos, growth)
			target_pos.x *= plant_area.x
			target_pos.y *= plant_area.y
			
			# Stem rendering
			var stemCurve = Curve2D.new()
			var line_start_pos = root_pos * plant_area
			stemCurve.add_point(line_start_pos)
			# for j in range(1,curvePointsAmount):
			# 	var lerped = line_start_pos.lerp(target_pos, 1.0 * j / curvePointsAmount)
			# 	var curvePoint = lerped + lerped.orthogonal().normalized() * 10
			# 	# what the fuck am i even doing here
				
			# 	stemCurve.add_point(curvePoint)
			stemCurve.add_point(target_pos)
			var line_points = stemCurve.get_baked_points()
			
			draw_polyline(line_points, stemColor, 3)
			draw_texture(leafTexture, target_pos-Vector2(16,16))
			connectionTuples.append([subleaf, subleaf.getSubleaves()])
	draw_texture(doniczkaTexture, Plant.pos * plant_area - Vector2(16,9))



@export var lightRect : TextureRect

func setLight(light):
	lightCoeff = light/500
	queue_redraw()

			
var elapsedTime = 0.0
func _process(delta):
	elapsedTime += delta
	position.y = sin(elapsedTime*2) * 2
@onready var Plant : Leaf = Leaf.new([], Vector2(0.5,0.7), Vector2(0.5,0.7), randi())
func _ready():
	var plantRandSeed = randi()
	Plant = Leaf.new([], Vector2(0.5,0.7), Vector2(0.5,0.7), plantRandSeed)
	Plant.generateSubleaves()





# what the fuck am i doing with my life it's 2:12 7.05.2024 and i have another fucking calculus test
