extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var offset = Vector2.ZERO;
	var tiling= Vector2.ONE;
	
	tiling.x = float(get_node("tilingX").text);
	tiling.y = float(get_node("tilingY").text);
	offset.x = float(get_node("offsetX").text);
	offset.y = float(get_node("offsetY").text);
	
	#self.material.set_shader_param("tiling", tiling);
	#self.material.set_shader_param("offset", offset);
	pass
