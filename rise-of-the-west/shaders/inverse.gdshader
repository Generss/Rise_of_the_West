shader_type canvas_item;

uniform vec4 color_a : source_color = vec4(0.1608, 0.1686, 0.1882, 1.0); // #292b30
uniform vec4 color_b : source_color = vec4(0.8118, 0.6706, 0.2902, 1.0); // #cfab4a

uniform float tolerance = 0.01;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);

	float dist_to_a = distance(tex_color.rgb, color_a.rgb);
	float dist_to_b = distance(tex_color.rgb, color_b.rgb);

	if (dist_to_a <= tolerance) {
		tex_color.rgb = color_b.rgb;
	} else if (dist_to_b <= tolerance) {
		tex_color.rgb = color_a.rgb;
	}

	COLOR = tex_color;
}