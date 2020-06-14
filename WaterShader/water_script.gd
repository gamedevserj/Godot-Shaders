extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(NodePath) var cameraPath

var scrHeight;
var calculatedOffset;

# Called when the node enters the scene tree for the first time.
func _ready():
	scrHeight = ProjectSettings.get_setting("display/window/size/height");

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var camZoom = get_node(cameraPath).zoom;
	calculatedOffset = (-get_node(cameraPath).position.y/(scrHeight) + self.position.y/scrHeight) * 2 / camZoom.y;
	self.material.set_shader_param("offset", calculatedOffset);
	
	self.material.set_shader_param("aspect", self.scale.y/self.scale.x);
	#pass

