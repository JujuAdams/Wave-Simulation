varying vec2 v_vTexcoord;
varying vec4 v_vColour;

float DecodeFloatRGBA(vec4 enc)
{
	vec4 kDecodeDot = vec4(1.0, 1.0/255.0, 1.0/65025.0, 1.0/16581375.0);
	return dot( enc, kDecodeDot );
}

void main()
{
    float value = DecodeFloatRGBA(texture2D(gm_BaseTexture, v_vTexcoord));
    gl_FragColor = vec4(value, value, value, 1.0);
}
