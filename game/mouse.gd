extends Node2D

@export var gradient : Gradient = null
var gradient_offset : float = 0.0

@export var button_left : Sprite2D = null
@export var button_right : Sprite2D = null

func _process(delta: float) -> void:
	gradient_offset += delta

	if gradient_offset >= 1.0:
		gradient_offset = 0.0

	var color = gradient.sample(gradient_offset)

	button_left.modulate = color
	button_right.modulate = color

	button_left.visible = Input.is_action_pressed("input_confirm")
	button_right.visible = Input.is_action_pressed("input_deny")