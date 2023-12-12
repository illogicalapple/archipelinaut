shader_type canvas_item;

uniform sampler2D noise : repeat_enable;
uniform sampler2D screen : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	vec4 screen_texture = texture(screen, SCREEN_UV * vec2(1.0, -1.0));
	COLOR = screen_texture;
}