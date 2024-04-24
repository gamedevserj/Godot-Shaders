shader_type canvas_item;

uniform sampler2D dissolveNoiseTexture : repeat_enable;
uniform float dissolveNoiseScale = 1;
uniform float dissolveAmount : hint_range(0, 1);
uniform float edgeThickness = 0.01;
uniform vec4 edgeColor : source_color;
uniform vec4 invisibilityTint : source_color;
uniform float tintStrength : hint_range(0., 1.);

uniform sampler2D distortionNoiseTexture : repeat_enable;
uniform vec2 distortionTiling = vec2(1., 1.);
uniform vec2 distortionSpeed = vec2(1., 1.);
uniform float distortionStrength : hint_range(0., 1.);

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment()
{
	vec4 originalTexture = texture(TEXTURE, UV);
	vec4 dissolveNoise = texture(dissolveNoiseTexture, UV * dissolveNoiseScale);

	vec4 step1 = step(dissolveAmount, dissolveNoise); // step function turns all values in the noise texture below dissolve amount to black and above to white
	vec4 step2 = step(dissolveAmount + edgeThickness, dissolveNoise);
	
	vec4 edge = step1 - step2; // difference between results of two step functions is the edge area
	vec4 edgeColorArea = edge * edgeColor; // setting the edge's color
	edgeColorArea.a = originalTexture.a; // setting the colored parts that are outside of the original texture to be transparent
	
	vec2 distortionNoiseOffset = texture(distortionNoiseTexture, UV * distortionTiling + TIME * distortionSpeed).rg;
	distortionNoiseOffset *= distortionStrength;

	vec4 screenTexture = texture(SCREEN_TEXTURE, SCREEN_UV + distortionNoiseOffset.rg);
	screenTexture.rgb = mix(screenTexture.rgb, invisibilityTint.rgb, tintStrength);
	vec4 invertedStep1 = 1.- step1; //white color from step1 is now black and vice versa

	vec4 originalAndEdge = mix(originalTexture, edgeColorArea, edge.r); // combinig original colors with borders
	vec4 combined = mix(originalAndEdge, screenTexture, invertedStep1);// using inverted step1 to combine original dissolved image with invisible part
	
	COLOR = combined;
}