extends Node2D


signal update_score(new_score)
signal offline_notification(income_amount, offline_time)


@onready var income_timer = $IncomeTimer


var multiplier := 1
var score := 0
var income := 0
var last_save_time 


# Save
func save_game():
	last_save_time = Time.get_unix_time_from_system()
	
	var save_dic = {
		"score" : score,
		"multiplier" : multiplier,
		"income" : income,
		"save_time" : last_save_time
	}
	return save_dic


# Load
func load_game(data : Dictionary):
	if data.has("score"):
		score = data["score"]
	if data.has("multiplier"):
		multiplier = data["multiplier"]
	if data.has("income"):
		income = data["income"]
	if data.has("save_time"):
		last_save_time = data["save_time"]


func _ready() -> void:
	if income > 0:
		calculate_offline_income()
		
		# Start income timer
		income_timer.start()
	
	UpgradeManager.connect("multiplier_changed", _on_multiplier_changed)
	UpgradeManager.connect("income_changed", _on_income_changed)
	
	# UI update
	emit_signal("update_score", score)
	UpgradeManager.refresh_ui()

func calculate_offline_income():
	var load_time = Time.get_unix_time_from_system()
	var offline_time : int = load_time - last_save_time
	offline_time = min(offline_time, 8 * 60 * 60)
	offline_time = round(offline_time)
	
	var offline_income = income * offline_time
	score += offline_income
	
	emit_signal("update_score", score)
	emit_signal("offline_notification", offline_income, offline_time)


func _on_click_area_clicked() -> void:
	score += 1 * multiplier
	emit_signal("update_score", score)


func _on_income_timer_timeout() -> void:
	score += income
	emit_signal("update_score", score)


func _on_upgrade_clicked(upgrade_id: Variant) -> void:
	var cost = UpgradeManager.get_cost(upgrade_id)
	
	if score >= cost:
		score -= cost
		UpgradeManager.buy_upgrade(upgrade_id)
		
		emit_signal("update_score", score)

func _on_multiplier_changed(new_multiplier: int):
	multiplier = new_multiplier


func _on_income_changed(new_income: int):
	income = new_income
	
	if income > 0:
		# Start income timer
		income_timer.start()
