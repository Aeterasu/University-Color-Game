@tool

class_name Circle2D extends Node2D

@export var filled : bool = true

@export var radius : float = 16.0
@export var width : float = 4.0
@export var points : int = 8
@export var color : Color = Color.WHITE

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	if filled:
		draw_circle(Vector2.ZERO, radius, color)
	else:
		draw_arc(Vector2.ZERO, radius, 0, TAU, points, color, width)