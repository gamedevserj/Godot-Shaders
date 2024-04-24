extends Node2D

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var tween = get_tree().create_tween();
			tween.tween_method(
			func(value): material.set_shader_parameter("dissolveAmount", value),  
			0.0, 1.0,  
			0.5);
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			var tween = get_tree().create_tween();
			tween.tween_method(
			func(value): material.set_shader_parameter("dissolveAmount", value),  
			1.0, 0.0,  
			0.5);
	
