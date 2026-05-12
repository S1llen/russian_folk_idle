extends Node2D


signal update_score(new_score)
signal update_upg_click(new_cost)
signal update_upg_chicken(new_cost)
signal offline_notification(income_amount, offline_time)


@onready var income_timer = $IncomeTimer


var multiplier := 1
var score := 0
var click_cost := 30
var income_per_second := 0
var chicken_cost := 60
var last_save_time 


# Save
func save_game():
	last_save_time = Time.get_unix_time_from_system()
	
	var save_dic = {
		"multiplier" : multiplier,
		"score" : score,
		"upg_click" : click_cost,
		"income" : income_per_second,
		"upg_chicken" : chicken_cost,
		"save_time" : last_save_time
	}
	return save_dic


# Load
func load_game(data : Dictionary):
	if data.has("multiplier"):
		multiplier = data["multiplier"]
	if data.has("score"):
		score = data["score"]
	if data.has("upg_click"):
		click_cost = data["upg_click"]
	if data.has("income"):
		income_per_second = data["income"]
	if data.has("upg_chicken"):
		chicken_cost = data["upg_chicken"]
	if data.has("save_time"):
		last_save_time = data["save_time"]


func _ready() -> void:
	if income_per_second > 0:
		calculate_offline_income()
		
		# Start income timer
		income_timer.start()
	
	emit_signal("update_score", score)
	emit_signal("update_upg_click", click_cost)
	emit_signal("update_upg_chicken", chicken_cost)
	
	UpgradeManager.connect("multiplier_changed", _on_multiplier_changed)
	UpgradeManager.connect("income_changed", _on_income_changed)


func calculate_offline_income():
	var load_time = Time.get_unix_time_from_system()
	var offline_time : int = load_time - last_save_time
	offline_time = min(offline_time, 8 * 60 * 60)
	offline_time = round(offline_time)
	
	var offline_income = income_per_second * offline_time
	score += offline_income
	
	emit_signal("update_score", score)
	emit_signal("offline_notification", offline_income, offline_time)


func _on_click_area_clicked() -> void:
	score += 1 * multiplier
	emit_signal("update_score", score)


func _on_income_timer_timeout() -> void:
	score += income_per_second
	emit_signal("update_score", score)


func _on_upgrade_button_pressed(upgrade_id: String) -> void:
	print(upgrade_id)


func _on_income_button_pressed() -> void:
	if score >= chicken_cost:
		score -= chicken_cost
		income_per_second = income_per_second + 1
		chicken_cost = round(chicken_cost * 1.65)
		
		emit_signal("update_score", score)
		emit_signal("update_upg_chicken", chicken_cost)
		
		if income_timer.is_stopped():
			income_timer.start()


func _on_upgrade_clicked(upgrade_id: Variant) -> void:
	var cost = UpgradeManager.get_cost(upgrade_id)
	
	if score >= cost:
		score -= cost
		
		UpgradeManager.buy_upgrade(upgrade_id)


func _on_multiplier_changed(new_multiplier: int):
	multiplier = new_multiplier
	print(multiplier)


func _on_income_changed(new_income: int):
	income_per_second = new_income
