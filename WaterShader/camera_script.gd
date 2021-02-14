extends Camera2D

export(float) var zoomIncrement = 0.05;
export(float) var positionIncrement = 0.1;
export(float) var speed = 1;

export(NodePath) var target;

var camZoom = Vector2(1,1);
var targetPos = Vector2.ZERO;

func _process(delta):
	self.zoom = camZoom;
	self.global_position = lerp(get_global_position(), get_node(target).position, delta*speed);
	
	if Input.is_key_pressed(KEY_W):
		get_node(target).position.y -= positionIncrement;
	elif Input.is_key_pressed(KEY_S):
		get_node(target).position.y += positionIncrement;
	if Input.is_key_pressed(KEY_A):
		get_node(target).position.x -= positionIncrement;
	elif Input.is_key_pressed(KEY_D):
		get_node(target).position.x += positionIncrement;
	pass

func _input(event):
	if(Input.is_mouse_button_pressed(4)): #wheel up
		camZoom -= Vector2.ONE * zoomIncrement;
	if(Input.is_mouse_button_pressed(5)): #wheel down
		camZoom += Vector2.ONE * zoomIncrement;
	#if event is InputEventKey and event.is_action_pressed(KEY_W):
	
