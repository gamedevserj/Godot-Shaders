extends Node

@export var cameraPath: NodePath

var scrHeight;
var calculatedOffset : float;

# Called when the node enters the scene tree for the first time.
func _ready():
	scrHeight = ProjectSettings.get_setting("display/window/size/viewport_height");

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var camZoom = get_node(cameraPath).zoom.y;
	
	var squashing = self.material.get_shader_parameter("squashing");
	
	var adjustingForCameraPos = (get_node(cameraPath).position.y/(scrHeight))*(1+squashing);
	var adjustingForObjectPos = (self.position.y/(scrHeight))*(1+squashing);

	calculatedOffset = -0.5 + 0.5*squashing +(adjustingForCameraPos - adjustingForObjectPos) * camZoom;
	
	self.material.set_shader_parameter("calculatedOffset", calculatedOffset);
	self.material.set_shader_parameter("calculatedAspect", self.scale.y/self.scale.x);

