shader_type canvas_item; 


uniform vec2 player;
uniform float radius;

float lerp(float a, float b, float t) 
{
	return (b - a) * t + a;
}

highp float random1d(float dt) {
    highp float c = 43758.5453;
    highp float sn = mod(dt, 3.14);
    return fract(sin(sn) * c);
}

highp float noise1d(float value) {
	highp float i = floor(value);
	highp float f = fract(value);
	return mix(random1d(i), random1d(i + 1.0), smoothstep(0.0, 1.0, f));
}

void fragment()
{
	vec2 size = vec2(textureSize(TEXTURE, 0));
	vec2 position = UV * size; 
	
	vec2 offsets[] = {
		vec2(1.0, 0.0),
		vec2(0.3, 0.2),
		vec2(-0.4, 0.6)
	};
	
	vec4 color = texture(TEXTURE, UV);
	
	float alpha = color.a;
	
	for (int i = 0; i < 3; ++i) {
		vec2 offset = offsets[i] * TIME * 0.01 + UV;
		offset = mod(offset, 1.0);
		
		
		color = mix(color, texture(TEXTURE, offset), 0.3);
	}
	
	color.a += 0.3;
	
	float dist = distance(player, position);
	float radius_time = radius + 10.0 * noise1d(TIME * 5.0);
	
	if (dist < radius_time)
	{
//		min( dist / radius, 1.0 );
//		color.a = dist / radius_time;
		
		color.a = lerp(0.0, color.a, dist / radius_time);
	}
	
	COLOR = color;
}