shader_type canvas_item;

void fragment() {
	if(texture(TEXTURE, UV).r - abs(0.5 - UV.x) * 2.0 - abs(0.5 - UV.y) * 2.0 < 0.15) {
		COLOR = vec4(1, 0, 0, 0);
	} else if(texture(TEXTURE, UV).r - abs(0.5 - UV.x) * 2.0 - abs(0.5 - UV.y) * 2.0 < 0.3) { // check brightness (it's gray so the red value will be the brightness)
		COLOR = vec4(0.44, 0.75, 0.87, 1);
	} else if(texture(TEXTURE, UV).r - abs(0.5 - UV.x) * 2.0 - abs(0.5 - UV.y) * 2.0 < 0.4) {
		COLOR = vec4(1, 0.96, 0.7, 1);
	} else {
		COLOR = vec4(0.81, 0.88, 0.54, 1);
	}
}