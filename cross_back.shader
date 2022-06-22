/*
	電子的十字背景シェーダー by あるる（きのもと 結衣） @arlez80
	Electric Cross Background Shader by KINOMOTO Yui @arlez80

	MIT License
*/
shader_type canvas_item;

const float PI = 3.1415926535;

uniform float speed = 0.05;
uniform vec2 scale = vec2( 8.0, 4.5 );
uniform float rotate_speed = 1.1;
uniform float line_width : hint_range( 0.0, 1.0 ) = 0.1;
uniform float line_size = 0.1;

uniform vec4 back_color : hint_color = vec4( 0.0, 0.0, 0.0, 1.0 );
uniform vec4 line_color : hint_color = vec4( 0.0, 1.0, 1.0, 1.0 );

float get_ratio_scan_line( float p )
{
	return max(
		-sin( mod( p, line_size ) / line_size * PI ) + line_width
	,	0.0
	) / line_width;
}

float hatch( vec2 src_uv, float time, float dir )
{
	float r = time * rotate_speed * dir;
	float c = cos( r );
	float s = sin( r );
	mat2 matr = mat2(
		vec2( c, s )
	,	vec2( -s, c )
	);
	vec2 uv = ( ( src_uv - vec2( 0.5, 0.5 ) ) * scale * time * 0.5 ) * matr;
	return clamp( 
		(
			get_ratio_scan_line( uv.x )
		+	get_ratio_scan_line( uv.y )
		) * sin( time * PI ) * 4.0
	,	0.0
	,	1.0
	);
}

void fragment( )
{
	float time = mod( TIME * speed, 0.3 ) / 0.3;
	float f = clamp(
		hatch( SCREEN_UV, time, 1.0 )
	+	hatch( SCREEN_UV, mod( time + 0.5, 1.0 ), -1.0 )
	,	0.0
	,	1.0
	);

	COLOR = mix( back_color, line_color, f );
}
