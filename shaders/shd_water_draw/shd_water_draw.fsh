const float boundary = 0.001;

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

float DecodeFloatRGBA(vec4 enc)
{
	vec4 kDecodeDot = vec4(1.0, 1.0/255.0, 1.0/65025.0, 1.0/16581375.0);
	return dot(enc, kDecodeDot);
}

void main()
{
    float pos = DecodeFloatRGBA(texture2D(gm_BaseTexture, vec2(v_vTexcoord.x, 1.0/4.0)));
    gl_FragColor = vec4(smoothstep(pos - boundary, pos + boundary, v_vTexcoord.y));
}
