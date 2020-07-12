shader_type canvas_item;


uniform float reflectionOffset = 0; // allows player to control reflection position
uniform float reflectionBlur = 0; // works only if projec's driver is set to GLES3, more information here https://docs.godotengine.org/ru/stable/tutorials/shading/screen-reading_shaders.html
uniform float calculatedOffset = 0; // this is controlled by script, it takes into account camera position and water object position, that way reflection stays in the same place when camera is moving
uniform float calculatedAspect = 1; // is controlled by script, ensures that noise is not affected by object scale
uniform sampler2D noiseTexture;
uniform float offsetStrength;
uniform float maxOffset;

uniform vec2 distortionScale = vec2(0.3, 0.3);
uniform vec2 distortionSpeed = vec2(0.01, 0.02);

uniform float waveSmoothing = .01;

uniform float mainWaveSpeed = 2.5;
uniform float mainWaveFrequency = 20;
uniform float mainWaveAmplitude = 0.005;

uniform float secondWaveSpeed = 2.5;
uniform float secondWaveFrequency = 20;
uniform float secondWaveAmplitude = 0.015;

uniform float thirdWaveSpeed = 2.5;
uniform float thirdWaveFrequency = 20;
uniform float thirdWaveAmplitude = 0.01;

uniform float squashing = 1.;

uniform vec4 shorelineColor : hint_color = vec4(1.);
uniform float shorelineSize : hint_range(0., 0.1) = 0.0025;
uniform float shorelineFoamSize : hint_range(0., 0.1) = 0.0025;
uniform float foamSpeed;
uniform vec2 foamScale;

void fragment()
{
	
	vec2 uv = SCREEN_UV; 
	uv.y = 1. - uv.y; // turning screen uvs upside down
	uv.y *= squashing;
	uv.y -= calculatedOffset;
	uv.y += reflectionOffset;
	
	vec2 noiseTextureUV = UV * distortionScale; 
	noiseTextureUV.y *= calculatedAspect;
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
	
	vec4 color = textureLod(SCREEN_TEXTURE, uv, reflectionBlur);
	
	//adding the wave amplitude at the end to offset it enough so it doesn't go outside the sprite's bounds
	float distFromTop = mainWaveAmplitude * sin(UV.x * mainWaveFrequency + TIME * mainWaveSpeed) + mainWaveAmplitude
	 			+ secondWaveAmplitude * sin(UV.x * secondWaveFrequency + TIME * secondWaveSpeed) + secondWaveAmplitude
				+ thirdWaveAmplitude * cos(UV.x * thirdWaveFrequency - TIME * thirdWaveSpeed) + thirdWaveAmplitude;

	float waveArea = UV.y - distFromTop;
	
	float shoreline = smoothstep(0.0, waveArea, shorelineSize); 
	color.rgb += shoreline * shorelineColor.rgb;
	
	float shorelineFoam = smoothstep(0.0, waveArea, shorelineFoamSize);
	vec2 foamNoiseUV = UV * foamScale; 
	foamNoiseUV.y *= calculatedAspect;
	foamNoiseUV.y -= TIME * foamSpeed;
	vec4 foamNoise = texture(noiseTexture, foamNoiseUV);
	shorelineFoam *= foamNoise.r;
	
	color.rgb += shorelineFoam * shorelineColor.rgb;
	
	float upperPart = 1.0 - step(0.0, waveArea); 
	waveArea = smoothstep(waveArea, 0., waveSmoothing * (1.-UV.y));
	waveArea -= upperPart;
	color.a *= waveArea;
	
	COLOR = color;
}