//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float resW;
uniform float resH;

uniform float iTime;


vec3 palette( float t )
{
	vec3 a = vec3(-0.092, 0.398, 0.610);
	vec3 b = vec3(0.588, 0.228, -0.312);
	vec3 c = vec3(1.000, 1.188, 1.000);
	vec3 d = vec3(0.000, 0.318, 2.158);
	return a + b*cos(6.28318*(c*t*d));
}


void main()
{
	vec2 uv = (v_vTexcoord*2.0 - vec2(resW,resH)) / resH;
	vec2 uv0 = uv;
	vec3 finalColor = vec3(0.0);
	float timeOffset = 0.04;

	for(float i = 0.0; i < 4.0; i++)
	{
		uv = fract(uv*1.5)-0.5;
		
		float d = length(uv)*exp(-length(uv0));
		
		vec3 col = palette(length(uv0) + i*.4 + iTime*timeOffset);
		
		d = sin(d*8. + iTime)/8.;
		d = abs(d);
		
		d = pow(0.01 / d, 1.2);
		
		finalColor += col*d;
	}
	
    gl_FragColor = vec4(finalColor, 1.0); // v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
}
