shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

void fragment() {
    // Grab the brightness value of the noise texture to use for colouring. 
    // It doesn't matter which channel we use as long 
    float brightness = texture(TEXTURE, UV).r - abs(0.5 - UV.x) * 2.0 - abs(0.5 - UV.y) * 2.0 ;
   if (brightness < 0.15) {
        
        discard;
        
    } else if (brightness < 0.3 && brightness > 0.29) {
        
        COLOR = vec4(1.0);
        
    } else if (brightness < 0.3) {
        
        COLOR = vec4(0.44, 0.75, 0.87, 1);
        
    } else if (brightness < 0.4) {
        
        COLOR = vec4(1, 0.96, 0.7, 1.0);
        
    } else {
        
        COLOR = vec4(0.81, 0.88, 0.54, 1.0);
        
    }
}