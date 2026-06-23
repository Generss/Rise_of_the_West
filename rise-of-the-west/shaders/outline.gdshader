shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(0.8118, 0.6706, 0.2902, 1.0);
uniform float outline_width : hint_range(0.0, 10.0) = 2.0;

void fragment() {
	vec4 current_pixel = texture(TEXTURE, UV);

	if (current_pixel.a > 0.0) {
		COLOR = current_pixel;
	}
	else {

		vec2 pixel_size = TEXTURE_PIXEL_SIZE * outline_width;

		float alpha = 0.0;

		alpha += texture(TEXTURE, UV + vec2(pixel_size.x, 0.0)).a;
		alpha += texture(TEXTURE, UV + vec2(-pixel_size.x, 0.0)).a;
		alpha += texture(TEXTURE, UV + vec2(0.0, pixel_size.y)).a;
		alpha += texture(TEXTURE, UV + vec2(0.0, -pixel_size.y)).a;

		alpha += texture(TEXTURE, UV + vec2(pixel_size.x, pixel_size.y)).a;
		alpha += texture(TEXTURE, UV + vec2(-pixel_size.x, pixel_size.y)).a;
		alpha += texture(TEXTURE, UV + vec2(pixel_size.x, -pixel_size.y)).a;
		alpha += texture(TEXTURE, UV + vec2(-pixel_size.x, -pixel_size.y)).a;

		if (alpha > 0.0) {
			COLOR = outline_color;
		} else {
			COLOR = current_pixel;
		}
	}
}