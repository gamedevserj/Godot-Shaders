extends Node2D

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var tween = get_node("Tween");
			tween.interpolate_property(get_material(), "shader_param/dissolveAmount", 0, 1, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT);
			tween.start();
		if event.button_index == BUTTON_RIGHT and event.pressed:
			var tween = get_node("Tween");
			tween.interpolate_property(get_material(), "shader_param/dissolveAmount", 1, 0, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT);
			tween.start();
	
