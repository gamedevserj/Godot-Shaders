shader_type canvas_item;

uniform sampler2D noiseTexture;
uniform float offsetStrength : hint_range(0, 1);

varying vec2 vertPos;

void vertex()
{
	vertPos = normalize(VERTEX);
}

void fragment()
{
	
	vec2 noiseOffset = texture(noiseTexture, UV).rg;
	
	noiseOffset *= offsetStrength;
	noiseOffset = smoothstep(0.0, 5.0, noiseOffset);
	
	noiseOffset *= vertPos;
	
	vec2 screenUV = SCREEN_UV; 
	screenUV.x -= noiseOffset.x;
	screenUV.y += noiseOffset.y;
	
	vec4 color = texture(SCREEN_TEXTURE, screenUV);
	color.a = texture(TEXTURE, UV).a;

	COLOR = color;
}