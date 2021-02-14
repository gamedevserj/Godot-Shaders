shader_type canvas_item;

uniform sampler2D noiseTexture;
uniform float noiseTiling = 2;
uniform float dissolveAmount : hint_range(0, 1);
uniform float edgeThickness = 0.01;
uniform vec4 edgeColor : hint_color;

void fragment()
{
	vec4 originalTexture = texture(TEXTURE, UV);
	
	vec4 dissolveNoise = texture(noiseTexture, UV * noiseTiling);
	
	// remapping to account for edge thickness
	float remappedDissolve = dissolveAmount * (1.01  + edgeThickness) - edgeThickness;

	vec4 step1 = step(remappedDissolve, dissolveNoise); // step function turns all values in the noise texture below dissolve amount to black and above to white
	vec4 step2 = step(remappedDissolve + edgeThickness, dissolveNoise);
	
	vec4 edgeArea = step1 - step2; // difference between results of two step functions is the edge area
	edgeArea.a = 1.; 
	
	edgeArea.a *= originalTexture.a;// setting the colored parts that are outside of the original texture to be transparent
	originalTexture.a *= step1.r;// making the parts lower than the dissolveAmount transparent
	
	// coloring the edge in separate variable to keep the rgb info that defines edge area in order to allow different edge colors to work properly
	vec4 coloredEdge = edgeArea * edgeColor;
	
	//combining colors based on the edge area
	vec4 combinedColor = mix(originalTexture, coloredEdge, edgeArea.r);
	COLOR = combinedColor;
}
	