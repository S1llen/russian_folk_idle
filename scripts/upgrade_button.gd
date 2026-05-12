extends Button


signal upgrade_clicked(upgrade_id)


@export var upgrade_id : String


func _ready() -> void:
	UpgradeManager.connect("upgrade_purchased", _on_update_text)


func _on_pressed() -> void:
	emit_signal("upgrade_clicked", upgrade_id)


func _on_update_text(upgrade_text: String, new_cost: int) -> void:
	text = upgrade_text + " " + str(new_cost)
