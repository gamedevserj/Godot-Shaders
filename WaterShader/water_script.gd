extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(NodePath) var cameraPath

export(bool) var deb;

var scrHeight;
var calculatedOffset : float;

# Called when the node enters the scene tree for the first time.
func _ready():
	scrHeight = ProjectSettings.get_setting("display/window/size/height");

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var camZoom = get_node(cameraPath).zoom.y;
	
	var squashing = self.material.get_shader_param("squashing");
	
	var adjustingForCameraPos = (get_node(cameraPath).position.y/(scrHeight * camZoom))*(1+squashing);
	var adjustingForObjectPos = (self.position.y/(scrHeight * camZoom))*(1+squashing);

	calculatedOffset = -0.5 + 0.5*squashing - adjustingForCameraPos + adjustingForObjectPos;
	
	self.material.set_shader_param("calculatedOffset", calculatedOffset);
	self.material.set_shader_param("calculatedAspect", self.scale.y/self.scale.x);


