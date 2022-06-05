shader_type canvas_item;

uniform float offsetStrength : hint_range(0, 1);
uniform float fadeAmount : hint_range(0, 1) = 1;
uniform float fadeSmoothing : hint_range(0, 1) = 0.5;
uniform vec4 fadeColor : hint_color;
uniform vec2 offset = vec2(0.5, 0.5);
uniform vec2 tiling = vec2(1.0, 1.0);

uniform float hypotenuse = 0.707;


void fragment()
{
	
	/*
	//step 1
	vec4 fadeMask = fadeColor;
	
	COLOR = fadeMask;
	*/
	
	/*
	//step 2
	vec4 fadeMask = fadeColor;
	
	vec2 center = UV;
	float fadeDistance = length(center);
	
	fadeMask.a = fadeDistance;
	
	COLOR = fadeMask;
	*/
	
	/*
	//step 3
	vec4 fadeMask = fadeColor;
	
	vec2 center = UV;
	float fadeDistance = length(center);
	
	fadeMask.a = step(fadeDistance, fadeAmount);
	
	COLOR = fadeMask;
	*/
	
	/*
	// step 4
	vec4 fadeMask = fadeColor;
	
	vec2 center = UV - 0.5;
	float fadeDistance = length(center);
	
	fadeMask.a = step(fadeDistance, fadeAmount);
	
	COLOR = fadeMask;
	*/
	
	/*
	// step 5
	vec4 fadeMask = fadeColor;
	
	vec2 center = UV - 0.5;
	float fadeDistance = length(center);
	
	float remappedFade = fadeAmount * hypotenuse;
	
	fadeMask.a = step(fadeDistance, remappedFade);
	
	COLOR = fadeMask;*/
	
	/*
	// step 6
	vec4 fadeMask = fadeColor;
	
	vec2 center = UV - 0.5;
	
	float fadeDistance = length(center);
	
	float remappedFade = fadeAmount * hypotenuse;
	
	fadeMask.a = smoothstep(0.0, 1.0 * fadeSmoothing, fadeDistance - remappedFade);
	
	COLOR = fadeMask;
	*/
	
	
	/*
	// step 7
	vec4 fadeMask = fadeColor;
	
	vec2 center = UV - 0.5;
	
	float fadeDistance = length(center);
	
	float invertedFadeAmount = 1.0 - fadeAmount;
	
	float remappedFade = invertedFadeAmount * hypotenuse;
	
	fadeMask.a = smoothstep(0.0, 1.0 * fadeSmoothing, fadeDistance - remappedFade);
	
	COLOR = fadeMask;*/
	
	/*
	// step 8
	vec4 fadeMask = fadeColor;
	
	vec2 center = UV - 0.5;
	
	float fadeDistance = length(center);
	
	float invertedFadeAmount = 1.0 - fadeAmount;
	
	float remappedFade = invertedFadeAmount * (invertedFadeAmount * hypotenuse + fadeSmoothing) - fadeSmoothing;
	
	fadeMask.a = smoothstep(0.0, 1.0 * fadeSmoothing, fadeDistance - remappedFade);
	
	COLOR = fadeMask;
	*/
	
	/*
	// step 9
	vec4 fadeMask = fadeColor;
	
	vec2 center = UV - offset;
	
	float fadeDistance = length(center);
	
	float invertedFadeAmount = 1.0 - fadeAmount;
	
	float remappedFade = invertedFadeAmount * (invertedFadeAmount * hypotenuse + fadeSmoothing) - fadeSmoothing;
	
	fadeMask.a = smoothstep(0.0, 1.0 * fadeSmoothing, fadeDistance - remappedFade);
	
	COLOR = fadeMask;
	*/
	
	
	// step 10
	vec4 fadeMask = fadeColor;
	
	vec2 center = UV * tiling - offset;
	
	float fadeDistance = length(center);
	
	float invertedFadeAmount = 1.0 - fadeAmount;
	
	float remappedFade = invertedFadeAmount * (invertedFadeAmount * hypotenuse + fadeSmoothing) - fadeSmoothing;
	
	fadeMask.a = smoothstep(0.0, 1.0 * fadeSmoothing, fadeDistance - remappedFade);
	
	COLOR = fadeMask;
	
	
	/*
	vec4 fadeMask = fadeColor;
	//vec2 center = UV - 0.5;
	vec2 center = UV * tiling - offset;
	
	// 0.70711 - hypotenuse of the triangle with sides 0.5 and 0.5
	//(value - from1) / (to1 - from1) * (to2 - from2) + from2
	// 0.70711 - is a hypotenuse of a triangle with sides of 0.5 and 0.5 - which are UV coordinates
	// we're using it so that the complete fade out/in happens when reaching the corner
	float fade = 1.0 - fadeAmount;
	//float remappedFade = (fade * (fade * 0.70711 + fadeSmoothing) - fadeSmoothing);
	float remappedFade = (fade * (fade * hypotenuse + fadeSmoothing) - fadeSmoothing);
	
	float step2 = smoothstep(0., 1.0 * fadeSmoothing, length(center) - remappedFade);
	fadeMask.a *= step2;

	COLOR = fadeMask;*/
	
	
}