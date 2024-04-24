shader_type canvas_item;

uniform float edgeDistortionStrength = 0;
uniform vec2 tiling = vec2(1,1); // is changed through code
uniform vec2 offset = vec2(0,0); // is changed through code
uniform float distortionSize : hint_range(0., 1.);
uniform float smoothingOuter : hint_range(0., 1.);
uniform float smoothingInner : hint_range(0., 1.);

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
varying vec2 vertPos;

float remap(float from1, float to1, float from2, float to2, float value)
{
	return (value - from1) / (to1 - from1) * (to2 - from2) + from2;
}

void vertex()
{
	vertPos = VERTEX;
}

void fragment()
{
	vec4 distortionOffset =  vec4(1.);

	vec2 center = UV * 2. - 1.;
	
	float outerCircle = 1.-smoothstep(1.-smoothingOuter, 1., length(center));
	float smoothing = remap(0., 1., 1. - distortionSize, 1., smoothingInner);
	float innerCircle = smoothstep(1.-distortionSize, smoothing, length(center));
	float difference = outerCircle * innerCircle;
	distortionOffset.rgb *= difference;
	
	distortionOffset.rg *= vertPos * TEXTURE_PIXEL_SIZE;
	distortionOffset.rgb *= edgeDistortionStrength;
	
	vec2 originalUV = SCREEN_UV * tiling + offset;
	originalUV -= distortionOffset.rg;
	vec4 color = texture(SCREEN_TEXTURE, originalUV);
	color.a = step(length(center), 1.);
	
	COLOR = color;
}
