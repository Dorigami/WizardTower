//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float mouseX;
uniform float mouseY;
uniform float resW;
uniform float resH;
uniform float iTime;

void main()
{
	vec2 uv = (v_vTexcoord/vec2(resW,resH))*2.0 - 1.0;
	uv.y *= resH/resW;

	
	vec3 col = vec3(0.0);
	
	col.r = uv.y;
	
    gl_FragColor = vec4(col, 1.0); // v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
}
