shader_type canvas_item;
render_mode unshaded;

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

//void vertex() {
	//float xFromCenter = 1.0;
	//float yFromCenter = VERTEX.y - 0.5;
	//
	//// float dist = distance(UV,vec2(0.5))*20.0;
	//
	////float new_x = VERTEX.x*cos(delta) - VERTEX.y*sin(delta);
    ////float new_y = VERTEX.y*cos(delta) + VERTEX.x*sin(delta);
	//float dist = TIME;
	//
	//// VERTEX += 10.0*vec2(sin(xFromCenter*TIME), cos(yFromCenter*TIME));
	//VERTEX.x = (VERTEX.x*cos(dist) - VERTEX.y*sin(dist));
	//VERTEX.y = (VERTEX.y*cos(dist) - VERTEX.x*sin(dist));
//}

void fragment() {
	vec2 uv = SCREEN_UV;
	// Rotate the position relatively to the center
	float dist = (6.0+2.0*sin(TIME*.3))*distance(uv, vec2(.5))/3.0;
	float rotX = uv.x*cos(dist) - uv.y*sin(dist);
	float rotY = uv.y*cos(dist) - uv.x*sin(dist);
	uv.x += 0.5;
	uv.x = rotX;
	uv.y = rotY;
	uv.y -= 0.5;
	
	float n = max(perlin_noise(uv, 5.0),0.3);
	
	vec4 green = vec4(0.0,0.7,0.0, 1.0);
	vec4 yellow = vec4(1.0,1.0,0.0,1.0);
	
	COLOR = vec4(vec3(n),1.0);
	COLOR *= green;
	COLOR.r += 0.2 * step(0.5,n);
}

