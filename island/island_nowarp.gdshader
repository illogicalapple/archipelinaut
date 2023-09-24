shader_type canvas_item;

void fragment() {
	if(texture(TEXTURE, UV).r < 0.15) {
		COLOR = vec4(0.44, 0.75, 0.87, 0);
	} else if(texture(TEXTURE, UV).r < 0.5) { // check brightness (it's gray so the red value will be the brightness)
		COLOR = vec4(0.44, 0.75, 0.87, 1);
	} else if(texture(TEXTURE, UV).r < 0.6) {
		COLOR = vec4(1, 0.96, 0.7, 1);
	} else {
		COLOR = vec4(0.81, 0.88, 0.54, 1);
	}
}