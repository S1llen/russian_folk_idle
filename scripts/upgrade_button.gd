extends Button


signal upgrade_clicked(button_id)


@export var button_id : String


func _ready() -> void:
	UpgradeManager.connect("update_button_text", _on_update_text)


func _on_pressed() -> void:
	emit_signal("upgrade_clicked", button_id)


func _on_update_text(upgrade_name: String, new_cost: int) -> void:
	if button_id == upgrade_name:
		text = upgrade_name + " " + str(new_cost)
