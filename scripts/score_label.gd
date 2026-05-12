extends Label


func _on_game_update_score(new_score: Variant) -> void:
	text = "SCORE: " + str(new_score)
