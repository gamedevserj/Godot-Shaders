shader_type canvas_item;

uniform vec4 ringColor : source_color = vec4(1.);

uniform float ringRadius : hint_range(0., 1.);
uniform float ringWidth = 0.2;
uniform float innerSmoothing : hint_range(0., 1.) = 1.;
uniform float outerSmoothing : hint_range(0., 1.) = 1.;

void fragment()
{
	vec2 center = UV * 2. - 1.;
	
	float halfWidth = ringWidth * 0.5;
	float centerRadius = ringRadius - halfWidth;
	float innerRadius = ringRadius - ringWidth;
	float lerpedOuter = clamp(mix(centerRadius, ringRadius, 1.-outerSmoothing), 0, ringRadius);
	float outerCircle = 1.-smoothstep(lerpedOuter, ringRadius, length(center));
	
	float lerpedCenter = clamp(mix(innerRadius, centerRadius, innerSmoothing), 0, centerRadius);
	float innerCircle = smoothstep(innerRadius, lerpedCenter, length(center));
	
	float ring = innerCircle * outerCircle;
	vec4 color = vec4(ringColor.rgb, ring);
	
	COLOR = color;
}