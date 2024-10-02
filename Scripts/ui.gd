extends CanvasLayer

var save_path = "user://savegame.save"

@onready var healthbar: ProgressBar = $HealthBar

var health

func _ready():
	load_data()
	Global.player_health = Global.max_player_health
	healthbar.init_health(Global.max_player_health)
	

func _physics_process(delta):
	if health != Global.player_health:
			health = Global.player_health
			healthbar._set_health(health)
	if health <= 0:
		Global.player_health = Global.max_player_health
		get_tree().reload_current_scene()

func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		if file:
			var save_data = file.get_var()
			Global.cherries = save_data.get("cherries", 150)
			Global.max_player_health = save_data.get("max_player_health", 100)
			print(save_data)
			file.close()
