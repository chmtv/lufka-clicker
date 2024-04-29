shader_type canvas_item;

vec2 squareImaginary(vec2 number){
	return vec2(
		pow(number.x,2)-pow(number.y,2),
		2.0*number.x*number.y
	);
}

const float maxIterations = 2000.0;
float iterateMandelbrot(vec2 coord){
	vec2 z = vec2(0,0);
	for(float i=0.0;i<maxIterations;i++){
		z = squareImaginary(z) + coord;
		if(length(z)>2.0) return i/maxIterations;
	}
	return maxIterations - log(log(dot(z, z)) / log(0.25+abs(cos(TIME/3.0))/8.0));
}

const float ratio = 0.5;
vec3 palette( in float t, in vec3 a, in vec3 b, in vec3 c, in vec3 d )
{
	c = vec3(1.0);
	d = vec3(1.0);
    return a + b*cos( 6.28318*(c*t+d) );
}

const float view = .35;
float smoothMod(float axis, float amp, float rad){
    float top = cos(PI * (axis / amp)) * sin(PI * (axis / amp));
    float bottom = pow(sin(PI * (axis / amp)), 2.0) + pow(rad, 2.0);
    float at = atan(top / bottom);
    return amp * (1.0 / 2.0) - (1.0 / PI) * at;
}
void fragment() {
	// vec2 screen_uv = vec2(SCREEN_UV.x*TIME, SCREEN_UV.y);
	float zoom = sin(TIME/3.0);
	//vec2 uv = ((SCREEN_UV - vec2(0.5)) * vec2(ratio, 1.0)) / exp(zoom - 1.25) + view;
	vec2 uv = (SCREEN_UV - 0.5 + sin(TIME*3.0)*0.01)/exp(zoom - 1.25) + view;
	
	float dist = (1.0+sin(TIME*0.2))*distance(uv, vec2(0.5));
	float rotX = uv.x*cos(dist) - uv.y*sin(dist);
	float rotY = uv.y*cos(dist) - uv.x*sin(dist);
	
	float result = iterateMandelbrot(vec2(rotX, rotY));
	COLOR.rgb = palette(fract(result + 0.5), vec3(.5), vec3(.5), 
                   vec3(1), vec3(.0, .1, .2));
	COLOR *= vec4(
		palette(
			.8, 
			vec3(0.650,0.500,0.310),
			 vec3(-0.650,0.500,0.600),
			 vec3(0.333,0.278,0.278),
			 vec3(0.660,0.000,0.667)),
		1.0);
	
	
}