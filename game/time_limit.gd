class_name TimeLimit extends Node

var base_limit : float = 5.0

var time_left : float = 0.0
var is_stopped : bool = false

signal on_ran_out_of_time

func _ready() -> void:
	reset()

func _physics_process(delta: float) -> void:
	if is_stopped:
		return

	time_left = max(time_left - delta, 0.0)
	
	if time_left <= 0.0:
		is_stopped = true
		on_ran_out_of_time.emit()

func reset() -> void:
	time_left = base_limit