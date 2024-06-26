shader_type canvas_item;

uniform float tintStrength : hint_range(0., 1.);
uniform vec4 waterColor : source_color = vec4(1.);
uniform float reflectionOffset = 0; // allows player to control reflection position
uniform float reflectionBlur = 0; // works only if projec's driver is set to GLES3, more information here https://docs.godotengine.org/ru/stable/tutorials/shading/screen-reading_shaders.html
uniform float calculatedOffset = 0; // this is controlled by script, it takes into account camera position and water object position, that way reflection stays in the same place when camera is moving
uniform float calculatedAspect = 1; // is controlled by script, ensures that noise is not affected by object scale
uniform sampler2D noiseTexture : repeat_enable;

uniform vec2 distortionScale = vec2(0.3, 0.3);
uniform vec2 distortionSpeed = vec2(0.01, 0.02);
uniform float distortionStrength = 0.01;
//uniform float distortionContrast = 0.1; // uncomment if you want more contrast for the water distortion

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

uniform vec4 shorelineColor : source_color = vec4(1.);
uniform float shorelineSize : hint_range(0., 0.1) = 0.0025;
uniform float foamSize : hint_range(0., 0.1) = 0.0025;
uniform float foamStrength : hint_range(0., 2.) = 0.0025;
uniform float foamSpeed;
uniform vec2 foamScale;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
void fragment()
{
	vec2 uv = SCREEN_UV; 
	uv.y = 1. - uv.y; // turning screen uvs upside down
	uv.y *= squashing;
	uv.y -= calculatedOffset;
	uv.y += reflectionOffset;
	
	vec2 noiseTextureUV = UV * distortionScale; 
	noiseTextureUV.y *= calculatedAspect;
	noiseTextureUV += TIME * distortionSpeed;
	vec2 waterDistortion = texture(noiseTexture, noiseTextureUV).rg;

	//waterDistortion = smoothstep(vec2(0.), waterDistortion.rg, vec2(1.-distortionContrast)); // uncomment if you want more contrast for the water distortion
	waterDistortion *= distortionStrength;
	uv += waterDistortion.rg;
	
	vec4 color = textureLod(SCREEN_TEXTURE, uv, reflectionBlur);
	color.rgb = mix(color.rgb, waterColor.rgb, tintStrength);
	
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

	vec4 foamNoise = texture(noiseTexture, UV * foamScale + TIME * foamSpeed);
	foamNoise.r = smoothstep(0.0, foamNoise.r, foamStrength); 
	
	float shorelineFoam = UV.y - distFromTop;
	shorelineFoam = smoothstep(0.0, shorelineFoam, foamSize);
	shorelineFoam *= foamNoise.r;
	color.rgb += shorelineFoam * shorelineColor.rgb;
	
	COLOR = color;
	//COLOR = vec4(waterDistortion, 1., 1.); // uncomment to preview distortion
}