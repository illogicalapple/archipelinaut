shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

void fragment() {
    // Grab the brightness value of the noise texture to use for colouring. 
    // It doesn't matter which channel we use as long 
    float brightness = texture(TEXTURE, UV).r - abs(0.5 - UV.x) * 2.0 - abs(0.5 - UV.y) * 2.0;

	if (brightness < 0.29) {
   
        discard;
		
    } else {
        
        COLOR = vec4(1.0);
        
    }
}