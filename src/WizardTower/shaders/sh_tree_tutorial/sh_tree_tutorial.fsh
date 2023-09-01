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

float TaperBox( vec2 p, float wb, float wt, float yb, float yt, float blur )
{
        // bottom edge
        float m = smoothstep(-blur, blur, p.y - yb);
        // top edge
        m *= smoothstep(blur, -blur, p.y - yt);
        
        // sides:  0 when p.y=yt & 1 when p.y=yb
        float w = mix(wb, wt, (p.y-yb) / (yt-yb) );
        p.x = abs(p.x);
        m *= smoothstep(blur, -blur, p.x-w);
        return m;
}

vec4 Tree( vec2 uv, vec3 col, float blur )
{
    //float m = TaperBox(uv, .03, .03, -.05, .25, blur); // trunk
    //     m += TaperBox(uv, .2, .1, .25, .5, blur); // canopy 1
    //     m += TaperBox(uv, .15, .05, .5, .75, blur); // canopy 2
    //     m += TaperBox(uv, .1, .0, .75, 1., blur); // top 
    float m = TaperBox(uv, .03, .03, -.05, .25, blur); // trunk
         m += TaperBox(uv, .2, .1, .25, .5, blur); // canopy 1
         m += TaperBox(uv, .15, .05, .5, .75, blur); // canopy 2
         m += TaperBox(uv, .1, .0, .75, 1., blur); // top 
    float shadow = TaperBox(uv-vec2(.2,0), .1, .5, .15, .25, blur);
    shadow += TaperBox(uv+vec2(.25,0), .1, .5, .45, .5, blur);
    shadow += TaperBox(uv-vec2(.25,0), .1, .5, .7, .75, blur);
    
    col -= shadow*.7; // multiply to alter intensity of the shadow
    //m = 1.;
    return vec4(col, m);
}

float GetHeight( float x )
{
    return sin(x*.433)+sin(x)*.3;
}

vec4 Layer(vec2 uv, float blur)
{
    vec4 col = vec4(0.0); 
    float id = floor(uv.x);
    float n = fract(sin(id*234.12)*5463.3)*2. - 1.; //  the values in parenthesies are arbitrary
    float x = n*.3;
    float y = GetHeight(uv.x);
    float ground = smoothstep(blur, -blur, uv.y+y); // draw ground
    col += ground;
    y=GetHeight(id + .5 + x); // the extra number is to sample from the middle of the fract box 
                              // and to adjust to the random x position
    
    uv.x = fract(uv.x)-.5;

    vec4 tree = Tree((uv-vec2(x, -y))*vec2(1,1.+n*.2), vec3(1), blur);

    // col.rg = uv;
    col = mix(col, tree, tree.a);
    col.a = max(ground, tree.a);
    return col;
}

float Hash21(vec2 p)
{
    p = fract(p*vec2(234.45, 765.34));
    p += dot(p, p+547.123);
    return fract(p.x*p.y);
}

void main()
{
	//vec2 uv = (v_vTexcoord*2.0 - vec2(resW,resH)) / resH;
	
    vec2 uv = ((v_vTexcoord-0.5*vec2(resW,resH)) / resH)*vec2(1.0,-1.0);
    vec2 M = (vec2(mouseX,mouseY)/vec2(resW,resH))*2.-1.; // mouse position from -1 to 1 (bL to tR)
    float t = iTime*.1;
    float blur = 0.005;
	
    //stars
    float twinkle = dot(length(sin(uv+t)), length(cos(uv*vec2(22.,6.7)-t*3.)));
    twinkle = sin(twinkle*10.0)*.5+.5;
    float stars = pow(Hash21(uv), 100.)*twinkle;
    vec4 col = vec4(stars);
	
	//moon
    float moon = smoothstep(0.01, -0.01, length(uv-vec2(.4,.2))-.15);
    col *= 1.-moon;
    moon *= smoothstep(-0.01, 0.1, length(uv-vec2(.5,.25))-.15);
    col += moon;
	
    // landscape
    vec4 layer;
    for(float i=0.; i<1.;i+=1./10.)
    {
        float scale = mix( 30., 1., i );
        blur = mix(.05, .005, i);
        layer = Layer(uv*scale+vec2(t+i*80.,i*1.1)-M, blur);
        layer.rgb *= (1.-i)*vec3(.9,.9,1.);
        col = mix(col, layer, layer.a);
    }
    layer = Layer(uv+vec2(t,1)-M, 0.06);
    col = mix(col, layer, layer.a);

    // draw x-y axis
    float thickness = 1./resH;
//    if(abs(uv.x)<thickness) col.g = 1.;
//    if(abs(uv.y)<thickness) col.g = 1.;

    gl_FragColor = col; 
}



