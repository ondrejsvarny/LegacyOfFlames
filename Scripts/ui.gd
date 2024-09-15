extends CanvasLayer

@onready var healthbar: ProgressBar = $HealthBar

var health

func _ready():
	healthbar.init_health(Global.player_health)

func _physics_process(delta):
	if health != Global.player_health:
			health = Global.player_health
			healthbar._set_health(health)
	if health <= 0:
		Global.player_health = 100
		get_tree().reload_current_scene()
