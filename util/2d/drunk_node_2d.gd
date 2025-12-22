@tool
class_name DrunkNode2D extends Node2D

@export var speed : float = 1.0
@export var offset : Vector2 = Vector2.ZERO
@export var strength : float = 1.0

func _physics_process(delta: float) -> void:
	var time : float = Time.get_ticks_msec()

	position.x = cos(time * speed / 2 * delta) * offset.x * strength
	position.y = sin(time * speed * delta) * offset.y * strength