shader_type canvas_item;

uniform sampler2D water_noise : repeat_enable;
uniform sampler2D distort_noise : repeat_enable;
uniform float SPEED = 0.1;
uniform float distort_strength = 0.1;
uniform vec2 direction = vec2(0);
uniform vec2 UV_SCALE = vec2(1);

// In this shader we're just simply combining two noise textures
// both distorted but inverted of eachother
void fragment() {
	
	float distort_value = texture(distort_noise, UV * UV_SCALE).r * distort_strength;
	vec2 modified_uv = UV * UV_SCALE * (distort_value);
	float timespeed = (TIME * SPEED);
	
	vec4 noise1 = texture(water_noise, modified_uv + (direction * timespeed));
	vec4 noise2 = texture(water_noise, modified_uv + (-direction * timespeed));
	COLOR = mix(noise1, noise2, 0.5);
}