extends Control

#var coins
var SpeedPrice = 10
var SpeedLevel = 1
var HealthPrice = 15
var HealthLevel = 1
var DamagePrice = 10
var DamageLevel = 1
var RelSpeedPrice = 10
var RelSpeedLevel = 1
var ProjSpeedPrice = 10
var ProjSpeedLevel = 1

@onready var speed_level: Label = %SpeedLevel
@onready var speed_button: Button = %UpgradeSpeed

@onready var health_level: Label = %HealthLevel
@onready var health_button: Button = %UpgradeHealth

@onready var fireball_damage_level: Label = %DamageLevel
@onready var fireball_damage_button: Button = %UpgradeDamage

@onready var fireball_rel_speed_level: Label = %RelSpeedLevel
@onready var fireball_rel_speed_button: Button = %UpgradeRelSpeed

@onready var fireball_proj_speed_level: Label = %ProjSpeedLevel
@onready var fireball_proj_speed_button: Button = %UpgradeProjSpeed

@onready var panel_container: PanelContainer = $PanelContainer

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/Menu.tscn")

# READY A PROCESS
func _ready() -> void:
	load_data()
	speed_level.text = "LEVEL " + str(SpeedLevel)
	speed_button.text = "x" + str(SpeedPrice) + " Upgrade"
	health_level.text = "LEVEL " + str(HealthLevel)
	health_button.text = "x" + str(HealthPrice) + " Upgrade"
	fireball_damage_level.text = "LEVEL " + str(DamageLevel)
	fireball_damage_button.text = "x" + str(DamagePrice) + " Upgrade"
	fireball_rel_speed_level.text = "LEVEL " + str(RelSpeedLevel)
	fireball_rel_speed_button.text = "x" + str(RelSpeedPrice) + " Upgrade"
	fireball_proj_speed_level.text = "LEVEL " + str(ProjSpeedLevel)
	fireball_proj_speed_button.text = "x" + str(ProjSpeedPrice) + " Upgrade"

func _process(delta: float) -> void:
	if Global.coins < SpeedPrice or SpeedLevel == 4:
		speed_button.disabled = true
		if SpeedLevel == 4:
			speed_button.text = "    MAX LEVEL    "
	else:
		speed_button.disabled = false
	
	if Global.coins < HealthPrice or HealthLevel == 4:
		health_button.disabled = true
		if HealthLevel == 4:
			health_button.text = " MAX LEVEL "
	else:
		health_button.disabled = false
		
	if Global.coins < DamagePrice or DamageLevel == 4:
		fireball_damage_button.disabled = true
		if DamageLevel == 4:
			fireball_damage_button.text = " MAX LEVEL "
	else:
		fireball_damage_button.disabled = false
	
	if Global.coins < RelSpeedPrice or RelSpeedLevel == 4:
		fireball_rel_speed_button.disabled = true
		if RelSpeedLevel == 4:
			fireball_rel_speed_button.text = " MAX LEVEL "
	else:
		fireball_rel_speed_button.disabled = false
	
	if Global.coins < ProjSpeedPrice or ProjSpeedLevel == 4:
		fireball_proj_speed_button.disabled = true
		if ProjSpeedLevel == 4:
			fireball_proj_speed_button.text = " MAX LEVEL "
	else:
		fireball_proj_speed_button.disabled = false
	
	
# PLAYER UPGRADES
func _on_upgrade_speed_pressed() -> void:
	Global.coins -= SpeedPrice
	#Global.speed + ...
	SpeedLevel += 1
	speed_level.text = "LEVEL " + str(SpeedLevel)
	SpeedPrice = 2*SpeedPrice
	speed_button.text = "x" + str(SpeedPrice) + " Upgrade"
	save()


func _on_upgrade_health_pressed() -> void:
	Global.coins -= HealthPrice
	Global.max_player_health += 25
	Global.player_health += 25
	HealthLevel += 1
	health_level.text = "LEVEL " + str(HealthLevel)
	HealthPrice = 2*HealthPrice
	health_button.text = "x" + str(HealthPrice) + " Upgrade"
	save()
	

# FIREBALL UPGRADES
func _on_upgrade_damage_pressed() -> void:
	Global.coins -= DamagePrice
	Global.fireball_damage += 10
	DamageLevel += 1
	fireball_damage_level.text = "LEVEL " + str(DamageLevel)
	DamagePrice = 2*DamagePrice
	fireball_damage_button.text = "x" + str(DamagePrice) + " Upgrade"
	save()
	


func _on_upgrade_rel_speed_pressed() -> void:
	Global.coins -= RelSpeedPrice
	RelSpeedLevel += 1
	Global.fireball_reload = "fireball_lvl" + str(RelSpeedLevel)
	fireball_rel_speed_level.text = "LEVEL " + str(RelSpeedLevel)
	RelSpeedPrice = 2*RelSpeedPrice
	fireball_rel_speed_button.text = "x" + str(RelSpeedPrice) + " Upgrade"
	save()


func _on_upgrade_proj_speed_pressed() -> void:
	Global.coins -= ProjSpeedPrice
	Global.fireball_speed += 0.5
	ProjSpeedLevel += 1
	fireball_proj_speed_level.text = "LEVEL " + str(ProjSpeedLevel)
	ProjSpeedPrice = 2*ProjSpeedPrice
	fireball_proj_speed_button.text = "x" + str(ProjSpeedPrice) + " Upgrade"
	save()


# SECOND ATTACK UPGRADES


# SAVE AND LOAD
func save():
	var data = {
		"SpeedPrice": SpeedPrice,
		"SpeedLevel": SpeedLevel,
		"HealthPrice": HealthPrice,
		"HealthLevel": HealthLevel,
		"DamagePrice": DamagePrice,
		"DamageLevel": DamageLevel,
		"RelSpeedPrice": RelSpeedPrice,
		"RelSpeedLevel": RelSpeedLevel,
		"ProjSpeedPrice": ProjSpeedPrice,
		"ProjSpeedLevel": ProjSpeedLevel,
	}
	SaveManager.save_section("character_menu", data)
	
	var upgrade_data = {
		"max_player_health": Global.max_player_health,
		"fireball_damage": Global.fireball_damage,
		"fireball_reload": Global.fireball_reload,
		"fireball_speed": Global.fireball_speed,
	}
	SaveManager.save_section("global_upgrade_data", upgrade_data)
	
	var currencies = {
		"coins": Global.coins,
		"silver_coins": Global.silver_coins
	}
	SaveManager.save_section("global_currencies", currencies)
	

func load_data():
	var data = SaveManager.load_section("character_menu")
	SpeedPrice = data.get("SpeedPrice", 10)  
	SpeedLevel = data.get("SpeedLevel", 1) 
	HealthPrice = data.get("HealthPrice", 15)
	HealthLevel = data.get("HealthLevel", 1)  
	DamagePrice = data.get("DamagePrice", 10)
	DamageLevel = data.get("DamageLevel", 1)
	RelSpeedPrice = data.get("RelSpeedPrice", 10)
	RelSpeedLevel = data.get("RelSpeedLevel", 1)
	ProjSpeedPrice = data.get("ProjSpeedPrice", 10)
	ProjSpeedLevel = data.get("ProjSpeedLevel", 1)
	
	var data2 = SaveManager.load_section("global_upgrade_data")
	Global.max_player_health = data2.get("max_player_health", 100)
	Global.fireball_damage = data2.get("fireball_damage", 10)
	Global.fireball_reload = data2.get("fireball_reload", "fireball_lvl1")
	Global.fireball_speed = data2.get("fireball_speed", 3)
	
	var data3 = SaveManager.load_section("global_currencies")
	Global.coins = data3.get("coins", 150)
