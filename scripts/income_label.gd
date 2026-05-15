extends Label


func _on_game_update_income(new_income: Variant) -> void:
	text = "INCOME: " + str(new_income)
