extends Button


func _on_game_update_upg_click(new_cost: Variant) -> void:
	text = "Spoon upgrade: " + str(new_cost)
