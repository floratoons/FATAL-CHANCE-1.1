shader_type canvas_item;

//repeats the image indefinitely
uniform sampler2D tex : repeat_enable;
//number of different items
uniform float n_rows = 10.0;
//current pos of the slots
uniform float y_offset = 0.0;

void fragment() {
	vec2 uv = UV;
	uv.y /= n_rows;
	uv.y += y_offset;
	COLOR.rgb *= texture(tex, uv).rgb;
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
