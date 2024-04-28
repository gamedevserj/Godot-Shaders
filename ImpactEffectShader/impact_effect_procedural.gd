extends Node2D

@export var animation_player : AnimationPlayer;


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
				self.position = get_global_mouse_position();
				animation_player.play("ShowImpact");

