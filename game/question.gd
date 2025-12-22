class_name Question extends RefCounted

var text_color : Stroop.Colors = Stroop.Colors.RED
var display_name : Stroop.Colors = Stroop.Colors.RED

func generate_new_question() -> void:
    var count = Stroop.Colors.size()

    text_color = randi() % count as Stroop.Colors
    display_name = randi() % count as Stroop.Colors