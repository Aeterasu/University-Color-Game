class_name Game extends Node

@export var label_center : Control = null
@export var label : Label = null
var current_question : Question = null

@export var time_progress_bar : ProgressBar = null
var time_limit : TimeLimit = null

@export var score_label : Label = null
var scoring : Scoring = null

func _ready() -> void:
	scoring = Scoring.new()
	time_limit = TimeLimit.new()
	time_limit.on_ran_out_of_time.connect(on_ran_out_of_time)

	add_child(time_limit)

	generate_new_question()

func _input(event: InputEvent) -> void:
	if event.is_pressed() and (event is InputEventKey):
		if event.physical_keycode == KEY_F1:
			generate_new_question()

func _physics_process(delta: float) -> void:
	if current_question:
		time_progress_bar.min_value = 0.0
		time_progress_bar.max_value = time_limit.base_limit
		time_progress_bar.value = time_limit.time_left

	if scoring:
		score_label.text = str(scoring.score) + " SCORE"\
		+ "\n" +\
		str(999) + " BEST"

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
	if not current_question:
		return

	if current_question.text_color == current_question.display_name:
		on_correct_answer()
	else:
		on_wrong_answer()

func deny() -> void:
	if not current_question:
		return

	if current_question.text_color != current_question.display_name:
		on_correct_answer()
	else:
		on_wrong_answer()

func on_correct_answer() -> void:
	generate_new_question()
	time_limit.reset()

	scoring.award_score()

func on_wrong_answer() -> void:
	get_tree().quit()

func on_ran_out_of_time() -> void:
	on_wrong_answer()
