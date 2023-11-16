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
	vec2 uv = (v_vTexcoord/vec2(resW,resH))*2.0 - 1.0;
	vec4 color = texture2D( gm_BaseTexture, v_vTexcoord );
	
	float dist = distance(vec2(mouseX,mouseY), uv) / 0.5;
	
	if(color.a > 0.) color.a = smoothstep(1., 0., dist);
	
    gl_FragColor = color;
}
