extends CanvasLayer

@onready var healthbar: ProgressBar = $Healthbar/HealthBar
@onready var attackbar1: ProgressBar = $Attack1bar/AttackBar
@onready var attackbar2: ProgressBar = $Attack2bar/AttackBar
@onready var dashbar: ProgressBar = $DashBar/DashBar
@onready var score: Label = %Score
@onready var death_timer: Timer = $DeathTimer

var health
var dead = false

func _ready():
	load_data()
	Global.player_health = Global.max_player_health
	healthbar.init_health(Global.max_player_health)
	
	# 2 timere kt sa bude menit dlzka podla prave vybratych abilitiek

func _physics_process(delta):
	if health != Global.player_health: # and is_instance_valid(healthbar):
			health = Global.player_health
			healthbar._set_health(health)
	if health <= 0 and dead == false:
		dead = true
		get_tree().call_group("player", "death")
		death_timer.start()

		
	if Input.is_action_just_pressed("attack") and Global.can_attack and Global.can_move:
		attackbar1.attack(Global.fireball_reload)
		get_tree().call_group("player", "attack")
		
	#if Input.is_action_just_pressed("attack2") and Global.can_attack and Global.can_move:
		#attackbar2.attack(Global.attack2)
	
	# UPDATING SCORE LABEL
	score.text = str(Global.coins)
	

func load_data():
	var data = SaveManager.load_section("global_upgrade_data")
	Global.max_player_health = data.get("max_player_health", 100)


func _on_death_timer_timeout() -> void:
	dead = false
	Global.player_health = Global.max_player_health
	get_tree().reload_current_scene()
