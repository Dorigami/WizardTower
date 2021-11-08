//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float range;
uniform vec4 color_match;
uniform vec4 color_replace;

void main()
{
	vec4 pixel_color = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	
	float new_range = range / 255.0;
	
	if(abs(pixel_color.r - color_match.r) <= new_range) {
		if(abs(pixel_color.g - color_match.g) <= new_range) {
			if(abs(pixel_color.b - color_match.b) <= new_range) {
				pixel_color.rgb = color_replace.rgb;
			}
		}
	}
	
    gl_FragColor = pixel_color;
}
