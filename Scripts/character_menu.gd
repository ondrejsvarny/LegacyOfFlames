extends Control


var SpeedPrice = 30
var SpeedLevel = 2

var HealthPrice = 15

@onready var speed_button: Button = $PanelContainer/AllContent/CharacterContent/VBox/Speed/UpgradeSpeed
@onready var speed_level: Label = $PanelContainer/AllContent/CharacterContent/VBox/Speed/SpeedLevel
@onready var abilities_content: PanelContainer = $PanelContainer/AllContent/AbilitiesContent
@onready var character_content: PanelContainer = $PanelContainer/AllContent/CharacterContent
@onready var panel_container: PanelContainer = $PanelContainer

func _on_character_button_pressed() -> void:
	character_content.visible = true
	abilities_content.visible = false
	# Create a new StyleBoxFlat
	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = Color(0.333, 0.333, 0.333)
	# Assign the StyleBoxFlat to the panel_container
	panel_container.add_theme_stylebox_override("panel", stylebox)

func _on_abilities_button_pressed() -> void:
	character_content.visible = false
	abilities_content.visible = true
	# Create a new StyleBoxFlat
	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = Color(0.169, 0.169, 0.169)
	# Assign the StyleBoxFlat to the panel_container
	panel_container.add_theme_stylebox_override("panel", stylebox)


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Global.cherries <= SpeedPrice or SpeedLevel == 4:
		speed_button.disabled = true
		if SpeedLevel == 4:
			speed_button.text = "  MAX LEVEL  "
	else:
		speed_button.disabled = false
	
	


func _on_upgrade_speed_pressed() -> void:
	Global.cherries = Global.cherries - SpeedPrice
	#Global.speed + ...
	SpeedLevel += 1
	speed_level.text = "LEVEL " + str(SpeedLevel)
	SpeedPrice = 2*SpeedPrice
	speed_button.text = "x" + str(SpeedPrice) + "  Upgrade"
	
	

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/Menu.tscn")
