shader_type canvas_item;

uniform vec4 ringColor : source_color = vec4(1.);

uniform float innerSmoothing : hint_range(0., 1.);
uniform float outerSmoothing : hint_range(0., 1.);
uniform float ringSize : hint_range(0., 1.);
uniform float ringWidth = 0.2;
uniform float maskSmoothing : hint_range(0., 1.);
uniform float noiseStrength : hint_range(0., 1.);
uniform sampler2D noiseTexture;

const float hypotenuse = 1.41;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
varying vec2 vertPos;

float remap(float input, float inputMin, float inputMax, float newMin, float newMax)
{
	return (input - inputMin) / (inputMax - inputMin) * (newMax - newMin) + newMin;
}

void fragment()
{
	vec2 center = UV * 2. - 1.;	

	float halfWidth = ringWidth * 0.5;
	
	float remappedRingSizeInner = remap(ringSize, 0., 1., 0., hypotenuse + halfWidth);
	float remappedRingSizeOuter = remap(ringSize, 0., 1., 0. - halfWidth, hypotenuse);
	// use this if you want the ring to be visible at ringSize=1
	//float remappedRingSizeInner = remap(ringSize, 0., 1., 0.  - halfWidth, 1.- halfWidth);
	//float remappedRingSizeOuter = remap(ringSize, 0., 1., 0. - halfWidth, 1.- halfWidth);
	float innerBorder = remappedRingSizeInner - halfWidth;
	float outerBorder = remappedRingSizeOuter + halfWidth;
	
	// having same values in first two parameters in smoothstep produces unwanted results
	float remappedInnerSmoothing = remap(innerSmoothing, 0., 1., 0., 0.999); 
	float smoothInner = mix(innerBorder, remappedRingSizeInner, remappedInnerSmoothing);
	float innerCircle = smoothstep(smoothInner, innerBorder, length(center));
	
	// having same values in first two parameters in smoothstep produces unwanted results
	float remappedOuterSmoothing = 0.999 - remap(outerSmoothing, 0., 1., 0., 0.999);
	float smoothOuter = mix(remappedRingSizeOuter, outerBorder, remappedOuterSmoothing);
	float outerCircle = 1. - smoothstep(outerBorder, smoothOuter, length(center));
	
	vec4 color = ringColor;
	float ring = 1. - (innerCircle + outerCircle);
	color.a = ring;
	
	COLOR = color;
}