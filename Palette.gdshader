shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D gradient : source_color, filter_nearest, repeat_disable; // 1 pixel per palette color
uniform int palette_size = 4; // number of colors in your palette image
uniform bool flip = false;

void fragment() {
	vec4 col = texture(screen_texture, SCREEN_UV);

	float lum = dot(col.rgb, vec3(0.2126, 0.7152, 0.0722)); // luminance
	if (flip) {
		lum = 1.0 - lum;
	}

	// Snap to one of N discrete steps, then sample that texel's center
	float n = float(palette_size);
	float idx = min(floor(lum * n), n - 1.0);
	float u = (idx + 0.5) / n;

	COLOR = vec4(texture(gradient, vec2(u, 0.5)).rgb, 1.0);
}