shader_type canvas_item;

uniform float fadeAmount : hint_range(0, 1) = 1;
uniform float fadeSmoothing : hint_range(0, 1) = 0.5;
uniform vec4 fadeColor : source_color;
uniform vec2 offset = vec2(0.5, 0.5);
uniform vec2 tiling = vec2(1.0, 1.0);

uniform float hypotenuse = 0.707;


void fragment()
{
	vec4 fadeMask = fadeColor;
	vec2 center = UV * tiling - offset;
	
	float fadeDistance = length(center);
	
	float invertedFadeAmount = 1.0 - fadeAmount;
	float remappedFade = invertedFadeAmount * (invertedFadeAmount * hypotenuse + fadeSmoothing) - fadeSmoothing;
	fadeMask.a = smoothstep(0.0, fadeSmoothing, fadeDistance - remappedFade);
	
	COLOR = fadeMask;
}