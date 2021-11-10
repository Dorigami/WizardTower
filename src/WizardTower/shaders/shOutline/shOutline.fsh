//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float pixelH;
uniform float pixelW;

void main()
{
    vec2 offsetx = vec2(pixelW, 0.0);
	vec2 offsety = vec2(0.0, pixelH);
	
	// define colors
	vec3 outlineCol = vec3(1.0,1.0,1.0);
	vec3 pixelColAdd = vec3(0.0,0.0,0.0);
	
	// get alpha of current texel
	float alpha = texture2D( gm_BaseTexture, v_vTexcoord ).a;

	// set outline color
	if(alpha == 0.0) 
	{
		pixelColAdd += outlineCol;
	} 

	// check for a bordering pixel(texel)
	alpha += ceil(texture2D( gm_BaseTexture, v_vTexcoord + offsetx).a);
	alpha += ceil(texture2D( gm_BaseTexture, v_vTexcoord - offsetx).a);
	alpha += ceil(texture2D( gm_BaseTexture, v_vTexcoord + offsety).a);
	alpha += ceil(texture2D( gm_BaseTexture, v_vTexcoord - offsety).a);
	
	
	gl_FragColor = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	gl_FragColor.a = alpha;
	gl_FragColor.rgb += pixelColAdd;

}
