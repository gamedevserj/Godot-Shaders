shader_type canvas_item;

uniform sampler2D dissolveNoiseTexture;
uniform float noiseScale = 2;
uniform float dissolveAmount : hint_range(0, 1);
uniform float edgeThickness = 0.01;
uniform vec4 edgeColor : hint_color;
uniform vec4 invisibilityTint : hint_color;

uniform sampler2D distortionNoiseTexture;
uniform vec2 distortionTiling = vec2(1., 1.);
uniform vec2 distortionSpeed = vec2(1., 1.);
uniform float distortionStrength = 0.1;

void fragment()
{
	vec4 originalTexture = texture(TEXTURE, UV);
	vec2 noiseTextureUV = UV * noiseScale; 
	
	vec4 dissolveNoise = texture(dissolveNoiseTexture, noiseTextureUV);

	vec4 step1 = step(dissolveAmount, dissolveNoise); // step function turns all values in the noise texture below dissolve amount to black and above to white
	vec4 step2 = step(dissolveAmount + edgeThickness, dissolveNoise);
	
	vec4 edge = step1 - step2; // difference between results of two step functions is the edge area
	vec4 edgeColorArea = edge * edgeColor; // setting the edge's color
	
	edgeColorArea.a = originalTexture.a; // setting the colored parts that are outside of the original texture to be transparent
	
	vec2 distortionTextureUV = UV * distortionTiling + TIME*distortionSpeed; 
	vec2 distortionNoiseOffset = texture(distortionNoiseTexture, distortionTextureUV).rg * distortionStrength;
	
	distortionNoiseOffset = smoothstep(vec2(0.1), vec2(1.,1.), distortionNoiseOffset);
	
	vec4 screenTexture = texture(SCREEN_TEXTURE, SCREEN_UV + distortionNoiseOffset);
	screenTexture += invisibilityTint;
	vec4 invertedStep1 = 1.- step1; //white color from step1 is now black and vice versa

	vec4 originalAndEdge = mix(originalTexture, edgeColorArea, edge.r); // combinig original colors with borders
	vec4 combined = mix(originalAndEdge, screenTexture, invertedStep1);// using inverted step1 to combine original dissolved image with invisible part
	
	COLOR = combined;
}