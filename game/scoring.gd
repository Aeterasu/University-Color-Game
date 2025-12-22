class_name Scoring extends RefCounted

var score : int = 0:
    set(value):
        value = maxi(value, 0)

        score = value
    get():
        return score

func award_score() -> void:
    score += 1