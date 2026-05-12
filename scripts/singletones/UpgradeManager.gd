extends Node


signal upgrade_purchased(upgrade_id : String, cost : int)
signal multiplier_changed(new_multiplier : int)
signal income_changed(new_income : int)


var upgrades = {}


func _ready() -> void:
	initialize_upgrades()


func initialize_upgrades():
	upgrades = {
		"Spoon": {
			"id": "spoon",
			"name": "Улучшенная Ложка",
			"level": 1,
			"base_cost": 30,
			"current_cost": 30,
			"cost_rate": 1.55,
			"type": "multiplier",
			"value": 1,
			"value_growth": 1,
		},
		"Ryaba": {
			"id": "ryaba",
			"name": "Курочка-Ряба",
			"level": 0,
			"base_cost": 60,
			"current_cost": 60,
			"cost_rate": 1.66,
			"type": "income",
			"value": 0,
			"value_growth": 1,
		}
	}


func get_cost(upgrade_id: String):
	return upgrades[upgrade_id].get("current_cost")


func buy_upgrade(upgrade_id: String):
	if not upgrades.has(upgrade_id):
		return
	
	var upgrade = upgrades[upgrade_id]
	
	upgrade["level"] += 1
	upgrade["current_cost"] = round(upgrade["current_cost"] * upgrade["cost_rate"])
	upgrade["value"] = upgrade["value"] + upgrade["value_growth"]
	
	emit_signal("upgrade_purchased", upgrade_id, upgrade["current_cost"])
	
	if upgrade["type"] == "multiplier":
		emit_signal("multiplier_changed", upgrade["value"])
	elif upgrade["type"] == "income":
		emit_signal("income_changed", upgrade["value"])
