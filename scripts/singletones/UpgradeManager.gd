extends Node


signal update_button_text(upgrade_name : String, cost : int)
signal multiplier_changed(new_multiplier : int)
signal income_changed(new_income : int)


var upgrades = {}


func _ready() -> void:
	init_default_upgrades()


func init_default_upgrades():
	upgrades = {
		"Spoon": {
			"id": "spoon",
			"name": "Улучшенная Ложка",
			"level": 1,
			"base_cost": 25,
			"current_cost": 25,
			"cost_rate": 1.11,
			"type": "multiplier",
			"value": 1,
			"value_growth": 1,
		},
		"Samovar": {
			"id": "samovar",
			"name": "Самовар",
			"level": 0,
			"base_cost": 50,
			"current_cost": 50,
			"cost_rate": 1.33,
			"type": "income",
			"value": 0,
			"value_growth": 1,
		},
		"Fisherman": {
			"id": "fisherman",
			"name": "Емеля",
			"level": 0,
			"base_cost": 75,
			"current_cost": 75,
			"cost_rate": 1.66,
			"type": "income",
			"value": 0,
			"value_growth": 3,
		},
		"Chicken": {
			"id": "chicken",
			"name": "Курочка-Ряба",
			"level": 0,
			"base_cost": 100,
			"current_cost": 100,
			"cost_rate": 1.99,
			"type": "income",
			"value": 0,
			"value_growth": 5,
		},
		"Firebird": {
			"id": "fire_bird",
			"name": "Жар-птица",
			"level": 0,
			"base_cost": 200,
			"current_cost": 200,
			"cost_rate": 2.22,
			"type": "income",
			"value": 0,
			"value_growth": 10,
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
	
	emit_signal("update_button_text", upgrade_id, upgrade["current_cost"])
	
	if upgrade["type"] == "multiplier":
		emit_signal("multiplier_changed", upgrade["value"])
	elif upgrade["type"] == "income":
		emit_signal("income_changed", upgrade["value"])


# Save
func save_upgrades():
	return upgrades


# Load
func load_upgrades(data: Dictionary):
	if data and not data.is_empty():
		upgrades = data.duplicate(true)
	

func refresh_ui():
	for id in upgrades:
		var upgrade_name : String = id
		var cost : int = upgrades[id].get("current_cost")
		
		emit_signal("update_button_text", upgrade_name, cost)
