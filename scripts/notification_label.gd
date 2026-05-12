extends Label


func _on_game_offline_notification(income_amount: Variant, offline_time: Variant) -> void:
	text = "Your helpers earns " + str(income_amount) + " in " + str(offline_time)
