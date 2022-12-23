shader_type canvas_item;

uniform float time;

void fragment() {
	if((texture(TEXTURE, UV).r - abs(0.5 - UV.x) * 2.0 - abs(0.5 - UV.y) * 2.0 < 0.4)) {
		COLOR = vec4(0, 0, 0, 0);
	} else {
		COLOR = vec4(0.81, 0.88, 0.54, 1);
	}
}