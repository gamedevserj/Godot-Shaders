shader_type canvas_item;

uniform sampler2D noiseTexture;
uniform float offsetStrength : hint_range(0, 1);

varying vec2 vertPos;

void vertex()
{
	vec4 test = PROJECTION_MATRIX * vec4(VERTEX.x, VERTEX.y, 0, 0);
	vertPos = VERTEX;
}

void fragment()
{
	
	vec2 noiseOffset = texture(noiseTexture, UV).rg;
	// without multiplication by screen pixel size the effect is too strong
	noiseOffset *= vertPos * SCREEN_PIXEL_SIZE;
	noiseOffset *= offsetStrength;
	
	vec2 uv = SCREEN_UV; 
	uv.x -= noiseOffset.x;
	uv.y += noiseOffset.y;
	
	vec4 color = texture(SCREEN_TEXTURE, uv);
	color.a = texture(TEXTURE, UV).a;
	//vec4 color = vec4(1.,1.,1.,1.);
	
	
	COLOR = color;
}