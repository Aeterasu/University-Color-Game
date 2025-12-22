class_name Game extends Node

@export var label : Label = null

var scoring : Scoring = null

func _ready() -> void:
	scoring = Scoring.new()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("input_confirm"):
		confirm()

	if Input.is_action_just_pressed("input_deny"):
		deny()

func generate_new_question() -> void:
	pass

func confirm() -> void:
	pass

func deny() -> void:
	pass

func on_correct_answer() -> void:
	scoring.award_score()