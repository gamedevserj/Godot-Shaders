extends TextureRect

@export var fadeDuration: float = 0.5;

var fadeAmount: float = 0.0;
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

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			targetPosition = _getNormalizedScreenPosition(event.position);
			_tweeenFade();

func _tweeenFade():
	_calculateAspect();
	_calculateOffset();
	_calculateHypotenuse();
	_setShaderParameters();
	var tween = get_tree().create_tween();
	tween.tween_method(
	  func(value): material.set_shader_parameter("fadeAmount", value),  
	  0.0, 1.0,  
	  fadeDuration);
	tween.tween_method(
	  func(value): material.set_shader_parameter("fadeAmount", value),  
	  1.0, 0.0,  
	  fadeDuration);
	pass

func _getNormalizedScreenPosition(screenPos):
	screenPos.x /= get_window().size.x;
	screenPos.y /= get_window().size.y;
	return screenPos;

func _calculateAspect():
	var size = get_window().size;
	if (size.x > size.y):
		aspect = float(size.x) / size.y;
		tiling.x = aspect;
		tiling.y = 1;
	else:
		aspect = float(size.y) / size.x;
		tiling.y = aspect;
		tiling.x = 1;
	pass

func _calculateOffset():
	offset = targetPosition;
	
	if (get_window().size.x > get_window().size.y):
		offset.x *= aspect;
	else:
		offset.y *= aspect;
		
	pass

func _calculateHypotenuse():
	var x = offset.x;
	var y = offset.y;
	
	var screenCenterNormalized = Vector2(0.5, 0.5);
	if(get_window().size.x > get_window().size.y):
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
	self.material.set_shader_parameter("hypotenuse", hypotenuse);
	self.material.set_shader_parameter("offset", offset);
	self.material.set_shader_parameter("tiling", tiling);
	pass
