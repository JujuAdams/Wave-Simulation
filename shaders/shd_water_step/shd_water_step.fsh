varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_fTexelX;
uniform float u_fTime;
uniform float u_fWind;

vec4 EncodeFloatRGBA(float v)
{
	vec4 kEncodeMul = vec4(1.0, 255.0, 65025.0, 16581375.0);
	float kEncodeBit = 1.0/255.0;
	vec4 enc = kEncodeMul * v;
	enc = fract(enc);
	enc -= enc.yzww * kEncodeBit;
	return enc;
}

float DecodeFloatRGBA(vec4 enc)
{
	vec4 kDecodeDot = vec4(1.0, 1.0/255.0, 1.0/65025.0, 1.0/16581375.0);
	return dot(enc, kDecodeDot);
}

void main()
{
    float pos  = DecodeFloatRGBA(texture2D(gm_BaseTexture, vec2(v_vTexcoord.x            , 1.0/4.0)));
    float posL = DecodeFloatRGBA(texture2D(gm_BaseTexture, vec2(v_vTexcoord.x - u_fTexelX, 1.0/4.0)));
    float posR = DecodeFloatRGBA(texture2D(gm_BaseTexture, vec2(v_vTexcoord.x + u_fTexelX, 1.0/4.0)));
    
    float speed = DecodeFloatRGBA(texture2D(gm_BaseTexture, vec2(v_vTexcoord.x, 3.0/4.0)));
    speed = 2.0*speed - 1.0;
    
    if (v_vTexcoord.y < 0.5)
    {
        pos += speed;
        pos += 0.05*(0.5*(posL + posR) - pos); //Surface tension
        pos += u_fWind*sin(7.5*sin(6.28*v_vTexcoord.x + 0.1*u_fTime)*mix(0.2, 0.8, 0.5 + 0.5*sin(u_fTime)) + 3.0*u_fTime); //Wind
        
        pos = clamp(pos, 0.001, 0.999);
        gl_FragColor = EncodeFloatRGBA(pos);
    }
    else
    {
        speed  = mix(speed, speed + 0.4*(0.5 - pos), 0.02); //Elasticity
        speed += 0.02*(0.5*(posL + posR) - pos); //Wave propagation
        speed *= 0.97; //Damping
        
        speed = clamp(0.5*speed + 0.5, 0.001, 0.999);
        gl_FragColor = EncodeFloatRGBA(speed);
    }
}
