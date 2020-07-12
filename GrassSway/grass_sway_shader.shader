shader_type canvas_item;

uniform float frequency = 1.;
uniform float amplitude = 1.;

//make sure to set object's offset to be at the bottom
void vertex()
{
	float vertPosX = (-VERTEX.y * sin(TIME * frequency) * amplitude) + VERTEX.x;
	VERTEX.x = vertPosX;
}