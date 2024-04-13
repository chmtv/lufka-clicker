shader_type canvas_item;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	vec2 finalUV = SCREEN_UV;
	finalUV = vec2(FRAGCOORD.x, FRAGCOORD.y);
	
	
	COLOR = texture(SCREEN_TEXTURE, finalUV);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
