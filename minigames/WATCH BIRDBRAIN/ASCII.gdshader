/*
	アスキー文字エフェクトシェーダー by あるる（きのもと 結衣） @arlez80
	Ascii Effect Shader by Yui Kinomoto @arlez80

	MIT License

	Ported to Godot 4
*/

shader_type canvas_item;
render_mode unshaded;

const vec3 MONOCHROME_SCALE = vec3( 0.298912, 0.586611, 0.114478 );

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D ascii_tex : source_color, repeat_disable, filter_nearest;
uniform vec2 ascii_size = vec2( 8.0, 16.0 );
uniform int available_columns = 10;
uniform int max_columns = 16;

void fragment( )
{
	vec2 screen_uv = floor( SCREEN_UV / SCREEN_PIXEL_SIZE / ascii_size ) * SCREEN_PIXEL_SIZE * ascii_size;
	vec2 diff = ascii_size * SCREEN_PIXEL_SIZE;
	vec4 color = (
		textureLod( screen_texture, screen_uv, 0.0 )
	+	textureLod( screen_texture, screen_uv + vec2( 0.0, diff.y ), 0.0 )
	+	textureLod( screen_texture, screen_uv + vec2( diff.x, 0.0 ), 0.0 )
	+	textureLod( screen_texture, screen_uv + diff, 0.0 )
	) / 4.0;

	vec2 ascii_uv = fract( SCREEN_UV / SCREEN_PIXEL_SIZE / ascii_size );
	ascii_uv.x = ( 1.0 - ascii_uv.x ) / float( max_columns );

	float avail = float( available_columns );
	float idx = min( floor( dot( color.rgb, MONOCHROME_SCALE ) * avail ), avail - 1.0 );

	COLOR = texture( ascii_tex, ascii_uv + vec2( idx / float( max_columns ), 0.0 ) );
}