extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(NodePath) var camera;

export(float) var zoom = 0.1;
export(float) var zoomIncrement;
export(bool) var control = true;

var xOffset;
var yOffset;

var screenWidth;
var screenHeight;

# Called when the node enters the scene tree for the first time.
func _ready():
	screenWidth = ProjectSettings.get_setting("display/window/size/width");
	screenHeight = ProjectSettings.get_setting("display/window/size/height");
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	xOffset = zoom * self.get_global_transform_with_canvas().origin.x/screenWidth;
	yOffset = zoom * (screenHeight - self.get_global_transform_with_canvas().origin.y)/screenHeight;

	#print(self.get_global_transform_with_canvas().origin.y);

	var tiling = Vector2(1 - zoom, 1 - zoom);
	var offset = Vector2(xOffset, yOffset);
	
	if(control):
		self.material.set_shader_param("offset", offset);
		self.material.set_shader_param("tiling", tiling);
	
	self.position = get_global_mouse_position();
	
func _input(event):
	if(Input.is_mouse_button_pressed(4)): #wheel up
		zoom += zoomIncrement;
	if(Input.is_mouse_button_pressed(5)): #wheel down
		zoom -= zoomIncrement;
