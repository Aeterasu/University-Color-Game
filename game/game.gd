class_name Game extends Node

@export var label_center : Control = null
@export var label : Label = null
var current_question : Question = null

var scoring : Scoring = null

func _ready() -> void:
	scoring = Scoring.new()

	generate_new_question()

func _input(event: InputEvent) -> void:
	if event.is_pressed() and (event is InputEventKey):
		if event.physical_keycode == KEY_F1:
			generate_new_question()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("input_confirm"):
		confirm()

	if Input.is_action_just_pressed("input_deny"):
		deny()

func generate_new_question() -> void:
	current_question = Question.generate_new_question()

	label.modulate = Stroop.get_color_value(current_question.text_color)
	label.text = Stroop.get_color_name(current_question.display_name)

	# animate this

	var tween : Tween = create_tween()
	tween.tween_property(label_center, "position", Vector2.ZERO, 0.5)\
		.from(Vector2.UP * 32.0)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)

func confirm() -> void:
	pass

func deny() -> void:
	pass

func on_correct_answer() -> void:
	scoring.award_score()