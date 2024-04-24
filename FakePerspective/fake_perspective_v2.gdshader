shader_type canvas_item;

uniform vec2 tiling = vec2(1., 4.);
uniform vec2 offset = vec2(0.);
uniform float perspective = 2.;

void fragment() {
	vec2 uv = UV;
	uv.x = uv.x * 2. - 1.;

	uv.x /= (1.0 + uv.y * perspective);
    uv.y /=  (1.0 + uv.y * perspective);
	uv = uv * tiling + offset;
	vec4 color = texture(TEXTURE, uv);
	COLOR = color;
}

