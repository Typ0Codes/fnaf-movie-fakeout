shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D gradient : source_color, filter_linear, repeat_disable; // any palette/gradient you want
uniform bool flip = false;

void fragment() {
	vec4 col = texture(screen_texture, SCREEN_UV);

	float lum = dot(col.rgb, vec3(0.2126, 0.7152, 0.0722)); // luminance

	col = texture(gradient, vec2(abs(float(flip) - lum), 0.5));

	COLOR = col;
}