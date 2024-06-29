shader_type canvas_item;
render_mode unshaded;

float rand(vec2 co){ return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453); }
// The following two functions are perlin noise code
vec2 hash_p( vec2 x ) {
    const vec2 k = vec2( 0.3183099, 0.3678794 );
    x = x*k + k.yx;
    return -1.0 + 2.0*fract( 16.0 * k*fract( x.x*x.y*(x.x+x.y)) );
}
float noise (in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    // Four corners in 2D of a tile
    float a = rand(i);
    float b = rand(i + vec2(1.0, 0.0));
    float c = rand(i + vec2(0.0, 1.0));
    float d = rand(i + vec2(1.0, 1.0));

    // Smooth Interpolation

    // Cubic Hermine Curve.  Same as SmoothStep()
    vec2 u = f*f*(3.0-2.0*f);
    // u = smoothstep(0.,1.,f);

    // Mix 4 coorners percentages
    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}

uniform float jaranie = 0.0;
void fragment() {
	vec2 uv = SCREEN_UV*7.5;
	
	float time = mod(TIME, 80);
	
	uv.y += time*3.0;
	uv.x += sin(SCREEN_UV.y*mod(time, 50.0)/5.0)/5.0;
	// uv.x += sin(uv.y*TIME*4.0)/20.0;
	
	float gradient = 1.0-SCREEN_UV.y;
	
	vec2 pos = uv;
	float n = noise(pos);
	n = n *3.0 * gradient;
	n = mix(n, 1.0, jaranie);
	// I fucking give up with cutting off the smoke it doesnt fucking work god fucking dammit
	
	if(n>0.99) {
		n = 1.0;
	}
	n = smoothstep(0.0, n, (jaranie)*SCREEN_UV.y) / 1.0;
    //n = step(jaranie, n) * n;
	
	// currently disabling to test the navier stokes smoke
	// COLOR *= vec4(vec3(n), 1.0);
}











