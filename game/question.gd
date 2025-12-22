class_name Question extends RefCounted

var text_color : Stroop.Colors = Stroop.Colors.RED
var display_name : Stroop.Colors = Stroop.Colors.RED

static func generate_new_question() -> Question:
    var result = Question.new()

    var count = Stroop.Colors.size()

    result.text_color = randi() % count as Stroop.Colors
    result.display_name = randi() % count as Stroop.Colors

    return result