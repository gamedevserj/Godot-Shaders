extends Node2D

export(float) var fadeDuration = 0.5;
export(float) var fadeAmount = 0.0;

var targetPosition = Vector2(0.0, 0.0);

var aspect = float(1.0);
var tiling = Vector2(1.0, 1.0);
var offset = Vector2(0.0, 0.0);
var hypotenuse = float(1.0);

func _ready():
	_calculateAspect();
	_calculateOffset();
	_calculateHypotenuse();
	pass 

func _process(delta):
	_setShaderParameters();
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			targetPosition = _getNormalizedScreenPosition(event.position);
			_fadeOut();

func _getNormalizedScreenPosition(screenPos):
	screenPos.x /= OS.window_size.x;
	screenPos.y /= OS.window_size.y;
	return screenPos;
	
func _fadeOut():
	_calculateOffset();
	_calculateHypotenuse();
	var tween = self.get_node("Tween");
	tween.interpolate_property(self, "fadeAmount", 0, 1, fadeDuration, Tween.TRANS_LINEAR);
	tween.interpolate_callback(self, fadeDuration + 0.1, "_fadeIn");
	tween.start();
	pass
	
func _fadeIn():
	var tween = self.get_node("Tween");
	tween.interpolate_property(self, "fadeAmount", 1, 0, fadeDuration, Tween.TRANS_LINEAR);
	tween.start();
	pass

func _calculateAspect():
	var size = OS.window_size;
	if(size.x > size.y):
		aspect = size.x / size.y;
		tiling.x = aspect;
		tiling.y = 1;
	else:
		aspect = size.y / size.x;
		tiling.y = aspect;
		tiling.x = 1;
	pass

func _calculateOffset():
	offset = targetPosition;
	
	if(OS.window_size.x > OS.window_size.y):
		offset.x *= aspect;
	else:
		offset.y *= aspect;
		
	pass

func _calculateHypotenuse():
	var x = offset.x;
	var y = offset.y;
	
	var screenCenterNormalized = Vector2(0.5, 0.5);
	if(OS.window_size.x > OS.window_size.y):
		screenCenterNormalized.x *= aspect;
	else:
		screenCenterNormalized.y *= aspect;
	
	# fade out center is in the left portion of the screen, calculate distance to the right side of the screen
	if(x < screenCenterNormalized.x):
		x = screenCenterNormalized.x * 2  - x;
	# fade out center is in the top portion of the screen, calculate distance to the bottom side of the screen
	if(y < screenCenterNormalized.y):
		y = screenCenterNormalized.y * 2  - y;
	
	hypotenuse = sqrt(x * x + y * y);
	
	pass

func _setShaderParameters():
	self.material.set_shader_param("fadeAmount", fadeAmount);
	self.material.set_shader_param("hypotenuse", hypotenuse);
	self.material.set_shader_param("offset", offset);
	self.material.set_shader_param("tiling", tiling);
	pass
