extends Camera2D

@export var zoomIncrement: float = 0.05;
@export var positionIncrement: float = 0.1;
@export var speed: float = 1;
@export var canBeMoved: bool = true;
@export var canZoom: bool = true;

@export var target: NodePath;

var camZoom = Vector2(1,1);
var targetPos = Vector2.ZERO;

func _ready():
	if(canZoom): camZoom = self.zoom;
pass

func _process(delta):
	if(canZoom): self.zoom = camZoom;
	if(canBeMoved):
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
	if(canZoom && Input.is_mouse_button_pressed(4)): #wheel up
		camZoom -= Vector2.ONE * zoomIncrement;
	if(canZoom && Input.is_mouse_button_pressed(5)): #wheel down
		camZoom += Vector2.ONE * zoomIncrement;
	#if event is InputEventKey and event.is_action_pressed(KEY_W):
	
