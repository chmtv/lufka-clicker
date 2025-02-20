extends Panel

var burnPercentage = 0.5
#@export var texture1 : Texture
#@export var texture2 : Texture
#@export var texture3 : Texture
#@export var texture4 : Texture
@export var textures : Array[Texture]
@export var sprite : TextureRect
func refreshPortrait():
	var curPortraitIndex = min(
		ceil( (burnPercentage-0.35) * textures.size() ),
		textures.size()-1
		)
	sprite.texture = textures[curPortraitIndex]
