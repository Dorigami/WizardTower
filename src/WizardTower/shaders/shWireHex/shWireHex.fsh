//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float mouseX;
uniform float mouseY;
uniform float resW;
uniform float resH;

void main()
{
	vec2 uv = v_vTexcoord / vec2(resW,resH);
	vec4 color = texture2D( gm_BaseTexture, v_vTexcoord );
	color = vec4(0.0,0.0,0.0,1.0);
	
	color.r = uv.x;
	
    gl_FragColor = color;
}
