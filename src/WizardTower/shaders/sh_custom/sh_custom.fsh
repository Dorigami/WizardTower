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
	
	float pi1 = 3.1415926535;
	float pi2 = 2.0*pi1;
	float timer = fract(iTime / 2.0);
	float signal_x = pow(smoothstep(0.0, 1.0, timer), 4.);
	signal_x += iTime / 8.;
	
	float angle = atan(uv.y, uv.x);
	float ro = cos(angle);
	float i = sin(angle);
	float rr = cos(signal_x * pi2);
	float ri = sin(signal_x * pi2);
	float diff = sqrt(pow(rr-ro, 2.) + pow(ri-i, 2.));
	
	vec3 col = vec3((rr/2.0+0.5)/3.0, ri/2.0+0.5, 1.0);
	
	float dist = abs(length(uv) - 0.4) * 2.;
	
	col *= 0.15 / (0.15 + dist);
	col *= 0.15 / (diff + 0.15);
	
    gl_FragColor = vec4(col, 1.0); // v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
}
