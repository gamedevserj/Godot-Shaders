shader_type canvas_item;

uniform sampler2D dissolveNoiseTexture;
uniform float noiseScale = 2;
uniform float dissolveAmount : hint_range(0, 1);
uniform float edgeThickness = 0.01;
uniform vec4 edgeColor : hint_color;

uniform sampler2D distortionNoiseTexture;
uniform vec2 distortionScale = vec2(1., 1.);
uniform vec2 distortionSpeed = vec2(1., 1.);
uniform float distortionStrength = 0.1;

void fragment()
{
	vec4 originalTexture = texture(TEXTURE, UV);
	vec2 noiseTextureUV = UV * noiseScale; 
	vec4 color = originalTexture;
	
	vec4 dissolveNoise = texture(dissolveNoiseTexture, noiseTextureUV);

	vec4 step1 = step(dissolveAmount, dissolveNoise); // step function turns all values in the noise texture below dissolve amount to black and above to white
	vec4 step2 = step(dissolveAmount + edgeThickness, dissolveNoise);
	
	vec4 difference = step1 - step2; // difference between results of two step functions is the edge area
	vec4 coloredEdge = difference * edgeColor; // setting the edge's color
	
	vec4 bordersColor = coloredEdge;
	bordersColor.a = difference.r; // setting the black part to be transparent
	bordersColor.a *= originalTexture.a; // setting the colored parts that are outside of the original texture to be transparent
	
	vec2 distortionTextureUV = UV * distortionScale + TIME*distortionSpeed; 
	vec2 distortionNoiseOffset = texture(distortionNoiseTexture, distortionTextureUV).rg * distortionStrength;
	
	vec4 screenTexture = texture(SCREEN_TEXTURE, SCREEN_UV + distortionNoiseOffset);
	vec4 invertedStep1 = 1.- step1; //white color from step1 is now black and vice versa
	screenTexture.a = step1.r; // setting the black portion of the texture to be transparent
	
	vec4 originalAndBorder = mix(originalTexture, bordersColor, difference.r); // combinig original colors with borders
	vec4 combined = mix(originalAndBorder, screenTexture, invertedStep1);// using inverted noise
	
	combined.a = originalTexture.a;
	
	COLOR = combined;
}