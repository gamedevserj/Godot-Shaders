extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(float) var power = 1;
export(float) var maxSize = 3;
export(float) var offsetDecreaseSpeed = 0.01;
export(float) var maxOffsetStrength = 0.178;


var currentScale = 0;
var currentOffsetStrength = 0;
var expand = false;
var decreaseStrength = false;


# Called when the node enters the scene tree for the first time.
func _ready():
	self.scale = Vector2.ZERO;
	currentOffsetStrength = maxOffsetStrength;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#self.scale += Vector2.ONE * currentScale;
	if(expand):
		if(self.scale.x < maxSize):
			self.scale += Vector2.ONE * power;
		else:
			expand = false;
			decreaseStrength = true;
	if(!expand && decreaseStrength):
		currentOffsetStrength -= offsetDecreaseSpeed;
		self.material.set_shader_param("offsetStrength", currentOffsetStrength);
		if(currentOffsetStrength <=0):
			_resetObject();
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if(!expand && !decreaseStrength): 
				self.position = get_global_mouse_position();
				expand = true;

func _resetObject():
	self.scale = Vector2.ZERO;
	currentOffsetStrength = maxOffsetStrength;
	self.material.set_shader_param("offsetStrength", maxOffsetStrength);
	expand = false;
	decreaseStrength = false;
	pass
