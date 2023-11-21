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
	vec2 uv = ((2.0*v_vTexcoord / vec2(resW,resH)) - 1.0);
	vec2 m_uv = 2.0 * vec2(mouseX, mouseY) / vec2(resW,resH); 
	vec4 sample = texture2D( gm_BaseTexture, v_vTexcoord );
	vec3 col = vec3(0.0);
	
	if(sample.a > 0.0)
	{
		float circle = smoothstep(0.01, -0.6, length(uv-m_uv) - 0.7);
		sample.a = circle;
	}

    gl_FragColor = sample;
}
