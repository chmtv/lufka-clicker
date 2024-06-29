shader_type canvas_item;


uniform float time = -1.2;
void fragment() {
	// Normalized pixel coordinates (from 0 to 1)
    // vec2 uv = FRAGCOORD.xy * SCREEN_PIXEL_SIZE.xy;
	vec2 uv = SCREEN_UV;

    float slope = 0.1;
    float width = 0.025;
    float n = step(time - width, uv.x - uv.y*slope) * step(uv.x - uv.y*slope, time + width);

    // Output to screen
    COLOR = vec4(n);
}