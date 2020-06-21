shader_type canvas_item;

//uniform int cameraOrthSize = 1;
uniform float offset = 0; // this is controlled by script, it takes into account camera position and water object position, that way reflection stays in the same place when camera is moving
uniform float aspect = 1; // is controlled by script, ensures that noise is not affected by object scale
uniform sampler2D noiseTexture;
uniform float offsetStrength;
uniform float maxOffset;

uniform vec2 distortionScale = vec2(0.3, 0.3);
uniform vec2 distortionSpeed = vec2(0.01, 0.02);

uniform float waveDepth = .013;
uniform float waveAreaDistanceFromTop = 1.5;

uniform float waveSpeed = 2.5;
uniform float waveFrequency = 20;
uniform float waveAmplitude = 1;

void fragment()
{
	
	vec2 uv = SCREEN_UV; 
	uv.y = 1. - uv.y - offset; // turning screen uvs upside down
	
	vec2 noiseTextureUV = UV * distortionScale; 
	noiseTextureUV.y *= aspect;
	noiseTextureUV += TIME * distortionSpeed; // scroll noise over time
	
	vec2 noiseOffset = texture(noiseTexture, noiseTextureUV).rg * offsetStrength;
	
	// remapping the noise
	//original formula --- output = (input - minInput) / (maxInput - minInput) * (maxOutput - minOutput) + minOutput
	// using 0 as minInput and 100 as maxInput
	noiseOffset.x = noiseOffset.x / 100. * maxOffset;
	
	// secondary noise to simulate smaller ripples, values are set to be too much to show off the effect
	/*vec2 noiseTextureUV2 = UV * distortionScale * 10.; 
	noiseTextureUV2.y *= aspect;
	noiseTextureUV2 += TIME * distortionSpeed * .5;
	
	vec2 noiseOffset2 = texture(noiseTexture, noiseTextureUV2).rg * offsetStrength;
	noiseOffset2.x = noiseOffset2.x / 100. * maxOffset;
	noiseOffset += noiseOffset2;*/
	
	uv += noiseOffset;
	vec4 color = texture(SCREEN_TEXTURE, uv);
	
	vec2 waveUv = UV;
	float dist = waveAmplitude * sin(waveUv.x * waveFrequency + TIME * waveSpeed) + waveAreaDistanceFromTop;
	
	float waveArea = waveUv.y * 1./waveDepth - dist;
	color.a *= waveArea;
	
	
	COLOR = color;
}