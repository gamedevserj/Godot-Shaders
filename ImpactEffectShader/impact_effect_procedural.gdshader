shader_type canvas_item;

uniform float ringRadius : hint_range(0., 1.) = 0.;
uniform float ringWidth = 0.2;
uniform float innerSmoothing : hint_range(0., 1.) = 1.;
uniform float outerSmoothing : hint_range(0., 1.) = 1.;

uniform float distortionStrength = 0.1;
uniform float distortionValue : hint_range(0, 1) = 1.;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

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
	vec2 noiseOffset = center * ring * distortionStrength * distortionValue;
	
	vec2 screenUV = SCREEN_UV; 
	screenUV += noiseOffset;
	
	vec4 color = vec4(vec3(0.), 1.);
	color = texture(SCREEN_TEXTURE, screenUV);
	
	COLOR = color;
}