//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec4 color_1;
uniform vec4 color_2;
uniform float _mix;

void main()
{
	vec4 col = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
    gl_FragColor = col*mix(color_1, color_2, _mix);//v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
}
