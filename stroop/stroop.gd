class_name Stroop

enum Colors
{
    RED,
    BLUE,
    GREEN,
}

static func get_color_name(color_enum : Stroop.Colors) -> String:
    match color_enum:
        Stroop.Colors.RED:
            return "Red".to_upper()
        Stroop.Colors.BLUE:
            return "Blue".to_upper()
        Stroop.Colors.GREEN:
            return "Green".to_upper()
        _:
            return ""

static func get_color_value(color_enum : Stroop.Colors) -> Color:
    match color_enum:
        Stroop.Colors.RED:
            return Color("FF004D")
        Stroop.Colors.BLUE:
            return Color("29ADFF")
        Stroop.Colors.GREEN:
            return Color("00E436")
        _:
            return Color(1.0, 1.0, 1.0)