@tool 
class_name ShakyNode2D extends Node2D

@export var force : float = 0.0
@export var decay_rate : float = 1.0

func _physics_process(delta: float) -> void:
    position = Vector2(randf_range(-force, force), randf_range(-force, force))
    force = max(force - decay_rate * delta, 0.0)

func shake(a : float) -> void:
    force += a