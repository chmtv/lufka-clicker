shader_type canvas_item;
render_mode unshaded;

uniform float uvCoeff = 1.0;

float rand(vec2 co){ return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453); }
vec2 n22 (vec2 p)
{
    vec3 a = fract(p.xyx * vec3(123.34, 234.34, 345.65));
    a += dot(a, a + 34.45);
    return fract(vec2(a.x * a.y, a.y * a.z));
}

vec2 get_gradient(vec2 pos)
{
    float twoPi = 6.283185;
    float angle = n22(pos).x * twoPi;
    return vec2(cos(angle), sin(angle));
}

float perlin_noise(vec2 uv, float cells_count)
{
    vec2 pos_in_grid = uv * cells_count;
    vec2 cell_pos_in_grid =  floor(pos_in_grid);
    vec2 local_pos_in_cell = (pos_in_grid - cell_pos_in_grid);
    vec2 blend = local_pos_in_cell * local_pos_in_cell * (3.0f - 2.0f * local_pos_in_cell);
    
    vec2 left_top = cell_pos_in_grid + vec2(0, 1);
    vec2 right_top = cell_pos_in_grid + vec2(1, 1);
    vec2 left_bottom = cell_pos_in_grid + vec2(0, 0);
    vec2 right_bottom = cell_pos_in_grid + vec2(1, 0);
    
    float left_top_dot = dot(pos_in_grid - left_top, get_gradient(left_top));
    float right_top_dot = dot(pos_in_grid - right_top,  get_gradient(right_top));
    float left_bottom_dot = dot(pos_in_grid - left_bottom, get_gradient(left_bottom));
    float right_bottom_dot = dot(pos_in_grid - right_bottom, get_gradient(right_bottom));
    
    float noise_value = mix(
                            mix(left_bottom_dot, right_bottom_dot, blend.x), 
                            mix(left_top_dot, right_top_dot, blend.x), 
                            blend.y);
   
    
    return (0.5 + 0.5 * (noise_value / 0.7));
}

uniform float randFactor = 0.1;
uniform float zchemolenie = 1.0;
void fragment()
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = SCREEN_UV;

    // time varying pixel color
    // vec3 col = 0.5 + 0.5*cos(uv.xyx+vec3(0,2,4));
	
	float time = mod(TIME, 90)*zchemolenie;
	float dist = (0.5*mod(time,70.0))*distance(uv, vec2(.5))/3.0;
	float rotX = uv.x*cos(dist) - uv.y*sin(dist);
	float rotY = uv.y*cos(dist) - uv.x*sin(dist);
	uv.xy += vec2(0.5*sin(time)/5.0);
	uv.x = rotX;
	uv.y = rotY;
	uv.xy -= vec2(0.5*cos(time)/5.0);
	


    // Position of the noise pixel
    vec2 pos = vec2(uvCoeff * uv * 1.0) + rand(uv)*randFactor;
    float n = perlin_noise(pos, 10.0);
    n += 0.35;

	
    // Output to screen
    // COLOR *= vec4((0.4*newUVx+0.6*newUVy)*2.5*sin(time),newUVx*5.0*sin(time*0.7), 0.5 + 0.5*abs((0.7*newUVx+0.3*newUVy)*sin(time)), 1.0);
	COLOR += vec4(
	n*uv.x*sin(time*1.0),
	n*uv.y*cos(time*2.0),
	n*sin(time/2.0)/2.0,
	1.0
	);
	COLOR *= vec4(vec3(n),1.0) * 2.0;
}
