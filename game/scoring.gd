class_name Scoring extends RefCounted

var score : int = 0:
    set(value):
        value = maxi(value, 0)

        score = value

        if score > personal_best:
            personal_best = score
    get():
        return score

static var personal_best : int = 0

func award_score() -> void:
    score += 1