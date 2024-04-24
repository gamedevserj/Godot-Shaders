shader_type canvas_item;

uniform vec2 offset = vec2(0.0);
uniform float perspective = 1.;
uniform float horizontalTiling = 1.;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
varying vec2 vertPos;
void vertex()
{
	vertPos = VERTEX;
}

void fragment() {
	vec2 uv = UV;
	uv = vec2(UV.r, UV.g * perspective) + vec2(-0.5, .5);
	uv.r *= horizontalTiling;

    vec3 viewDir = normalize(vec3(uv, -1.));
    vec2 planarUV = viewDir.xz/abs(viewDir.y);
	vec4 color = texture(TEXTURE, planarUV + offset);
	COLOR = vec4(uv, 0., 1.);
	COLOR = color;
}

