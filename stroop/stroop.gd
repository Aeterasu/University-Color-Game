class_name Stroop

enum Colors
{
    RED,
    BLUE,
    GREEN,
}

func get_color_name(color_enum : Stroop.Colors) -> String:
    match color_enum:
        Stroop.Colors.RED:
            return "Red"
        Stroop.Colors.BLUE:
            return "Blue"
        Stroop.Colors.GREEN:
            return "Green"
        _:
            return ""