shader_type canvas_item;

uniform sampler2D gradientTexture;
uniform float edgeDistortionStrength = 0;
uniform vec2 tiling = vec2(1,1); // is changed through code
uniform vec2 offset = vec2(0,0); // is changed through code

varying vec2 vertPos;

void vertex()
{
	vertPos = VERTEX;
}

void fragment()
{
	vec4 distortionOffset = texture(gradientTexture, UV);
	
	distortionOffset.rg *= vertPos * TEXTURE_PIXEL_SIZE;
	distortionOffset *= edgeDistortionStrength;
	
	vec2 originalUV = SCREEN_UV;
	originalUV = originalUV * tiling + offset;
	originalUV.x -= distortionOffset.r;
	originalUV.y += distortionOffset.g;
	
	vec4 color = texture(SCREEN_TEXTURE, originalUV);
	
	color.a = texture(TEXTURE, UV).a;
	
	COLOR = color;
}