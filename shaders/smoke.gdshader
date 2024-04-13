shader_type canvas_item;
render_mode unshaded;

uniform float uvCoeff = 1.0;


// 2D Noise based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
float rand(vec2 co){ return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453); }

// Perlin noise code
vec2 hash_p( vec2 x ) {
    const vec2 k = vec2( 0.3183099, 0.3678794 );
    x = x*k + k.yx;
    return -1.0 + 2.0*fract( 16.0 * k*fract( x.x*x.y*(x.x+x.y)) );
}
float perlin_noise( in vec2 p ) {
    vec2 i = floor( p );
    vec2 f = fract( p );

	vec2 u = f*f*(3.0-2.0*f);

    return mix( mix( dot( hash_p( i + vec2(0.0,0.0) ), f - vec2(0.0,0.0) ),
                     dot( hash_p( i + vec2(1.0,0.0) ), f - vec2(1.0,0.0) ), u.x),
                mix( dot( hash_p( i + vec2(0.0,1.0) ), f - vec2(0.0,1.0) ),
                     dot( hash_p( i + vec2(1.0,1.0) ), f - vec2(1.0,1.0) ), u.x), u.y);
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

void fragment()
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = FRAGCOORD.xy / 2.0;
	float time = mod(TIME, 50.0);
	
	uv.x += sin(uv.y*time/4.0)/4.0;
    uv.y += time*4.0;
	
    vec2 pos = uv;
	float n = noise(pos);
	n += 0.5;
	
    // Output to screen
    COLOR *= vec4(vec3(n),1.0);
	COLOR *= vec4(n);
}
