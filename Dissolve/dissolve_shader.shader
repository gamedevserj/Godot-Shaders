shader_type canvas_item;

uniform sampler2D noiseTexture;
uniform float noiseScale = 2;
uniform float dissolveAmount : hint_range(0, 1);
uniform float edgeThickness = 0.01;
uniform vec4 edgeColor : hint_color;

void fragment()
{
	vec4 originalTexture = texture(TEXTURE, UV);
	vec2 noiseTextureUV = UV * noiseScale; 
	vec4 color = originalTexture;
	
	vec4 dissolveNoise = texture(noiseTexture, noiseTextureUV);

	vec4 step1 = step(dissolveAmount, dissolveNoise); // step function turns all values in the noise texture below dissolve amount to black and above to white
	vec4 step2 = step(dissolveAmount + edgeThickness, dissolveNoise);
	
	vec4 difference = step1 - step2; // difference between results of two step functions is the edge area
	vec4 coloredEdge = difference * edgeColor; // setting the edge's color

	vec4 textureAndEdge = originalTexture + coloredEdge; // adding the edge color to the original texture
	textureAndEdge.a *= step1.r; // multiplying alpha by step1 red channel (can be green or blue as well), completely black areas will be transparent

	COLOR = textureAndEdge;
}
	