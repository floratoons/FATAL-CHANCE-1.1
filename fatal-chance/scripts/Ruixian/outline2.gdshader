shader_type canvas_item;

uniform float outline_width : hint_range(0, 10) = 3.0;
uniform vec4 outline_color : source_color = vec4(1, 1, 1, 1);
uniform bool show_outline = false;

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    
    if (show_outline) {
        vec2 size = outline_width * TEXTURE_PIXEL_SIZE;
        bool is_edge = UV.x < size.x || UV.x > 1.0 - size.x || 
                       UV.y < size.y || UV.y > 1.0 - size.y;
        if (is_edge) {
            color = outline_color;
        }
    }
    
    COLOR = color;
}