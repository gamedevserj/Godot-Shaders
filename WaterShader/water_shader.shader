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
uniform vec2 distortionStrength = vec2(0.01, 0.02);

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
uniform float foamSize : hint_range(0., 0.1) = 0.0025;
uniform float foamStrength : hint_range(0., 2.) = 0.0025;
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
	
	vec2 waterDistortion = texture(noiseTexture, noiseTextureUV).rg;
	waterDistortion.rg *= distortionStrength.xy;
	waterDistortion.xy = smoothstep(0.0, 5., waterDistortion.xy); 
	uv += waterDistortion;
	
	vec4 color = textureLod(SCREEN_TEXTURE, uv, reflectionBlur);
	
	//adding the wave amplitude at the end to offset it enough so it doesn't go outside the sprite's bounds
	float distFromTop = mainWaveAmplitude * sin(UV.x * mainWaveFrequency + TIME * mainWaveSpeed) + mainWaveAmplitude
	 			+ secondWaveAmplitude * sin(UV.x * secondWaveFrequency + TIME * secondWaveSpeed) + secondWaveAmplitude
				+ thirdWaveAmplitude * cos(UV.x * thirdWaveFrequency - TIME * thirdWaveSpeed) + thirdWaveAmplitude;

	float waveArea = UV.y - distFromTop;
	

	waveArea = smoothstep(0., 1. * waveSmoothing, waveArea);
	
	color.a *= waveArea;

	float shorelineBottom = UV.y - distFromTop - shorelineSize;
	shorelineBottom = smoothstep(0., 1. * waveSmoothing,  shorelineBottom);
	
	float shoreline = waveArea - shorelineBottom;
	color.rgb += shoreline * shorelineColor.rgb;
	
	//this approach allows smoother blendign between shoreline and foam
	/*
	float shorelineTest1 = UV.y - distFromTop;
	shorelineTest1 = smoothstep(0.0, shorelineTest1, shorelineSize);
	color.rgb += shorelineTest1 * shorelineColor.rgb;
	*/
	
	vec4 foamNoise = texture(noiseTexture, UV* foamScale + TIME * foamSpeed);
	foamNoise.r = smoothstep(0.0, foamNoise.r, foamStrength); 
	
	float shorelineFoam = UV.y - distFromTop;
	shorelineFoam = smoothstep(0.0, shorelineFoam, foamSize);
	
	shorelineFoam *= foamNoise.r;
	color.rgb += shorelineFoam * shorelineColor.rgb;
	
	COLOR = color;
}