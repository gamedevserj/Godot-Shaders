extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

@export var camera: NodePath;

@export var zoom: float = 0.1;
@export var zoomIncrement: float;
@export var control: bool = true;

var xOffset;
var yOffset;

var screenWidth;
var screenHeight;

# Called when the node enters the scene tree for the first time.
func _ready():
	screenWidth = ProjectSettings.get_setting("display/window/size/viewport_width");
	screenHeight = ProjectSettings.get_setting("display/window/size/viewport_height");
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	xOffset = zoom * self.get_global_transform_with_canvas().origin.x/screenWidth;
	yOffset = zoom * self.get_global_transform_with_canvas().origin.y/screenHeight;

	#print(self.get_global_transform_with_canvas().origin.y);

	var tiling = Vector2(1 - zoom, 1 - zoom);
	var offset = Vector2(xOffset, yOffset);
	
	
	self.material.set_shader_parameter("offset", offset);
	self.material.set_shader_parameter("tiling", tiling);
	if(control):
		self.position = get_global_mouse_position();
	
func _input(event):
	if(Input.is_mouse_button_pressed(4)): #wheel up
		zoom += zoomIncrement;
	if(Input.is_mouse_button_pressed(5)): #wheel down
		zoom -= zoomIncrement;
	if(Input.is_action_just_pressed("test")):
		var tiling = Vector2(1 - zoom, 1 - zoom);
		var offset = Vector2(xOffset, yOffset);
		print("tiling = ");
		print(tiling);
		print("offset = ");
		print(offset);
		print("zoom = ");
		print(zoom);
		print("self.get_global_transform_with_canvas().origin.x");
		print(self.get_global_transform_with_canvas().origin.x);
		print("screenWidth");
		print(screenWidth);
