extends CanvasLayer

@onready var healthbar: ProgressBar = $Healthbar/HealthBar
@onready var attackbar: ProgressBar = $Attack1bar/AttackBar
@onready var dashbar: ProgressBar = $DashBar/DashBar
@onready var score: Label = %Score
@onready var death_timer: Timer = $DeathTimer
@onready var time_label: Label = %TimeLabel
@onready var score_silver: Label = %ScoreSilver
@onready var music: AudioStreamPlayer2D = %Music

@onready var dash_potion_timer: Timer = $DashPotionTimer
@onready var attack_potion_timer: Timer = $AttackPotionTimer

@onready var picked_up_sprite: Sprite2D = %PickedUpSprite
const BLUE_POTION = preload("res://Assets/Tilesets/potions/blue_potion.png")
const PURPLE_POTION = preload("res://Assets/Tilesets/potions/purple_potion.png")
const RED_POTION = preload("res://Assets/Tilesets/potions/red_potion.png")

const BLUE_BAR = preload("res://Assets/UI/Bars/blue_bar.tres")
const GREEN_BAR = preload("res://Assets/UI/Bars/green_bar.tres")

var current_checkpoint : checkpoint
var health
var dead = false

var cooldown
var attack

func _ready():
	Global.picked = null
	load_data()
	#picked_up_sprite.texture = PURPLE_POTION
	Global.player_health = Global.max_player_health
	healthbar.init_health(Global.max_player_health)

func _physics_process(delta):
	# PICKED UP
	if Global.picked == "dash":
		picked_up_sprite.texture = BLUE_POTION
	elif Global.picked == "attack":
		picked_up_sprite.texture = PURPLE_POTION
	elif Global.picked == "heal":
		picked_up_sprite.texture = RED_POTION
	else:
		picked_up_sprite.texture = null
		
	if Input.is_action_just_pressed("use"):
		_on_picked_up_butt_pressed()
	
	# DASH POTION
	if Global.dash_cooldown == "dash_special":
		dashbar.add_theme_stylebox_override("fill", BLUE_BAR)
		if dash_potion_timer.is_stopped():
			dash_potion_timer.start()
	else:
		dashbar.add_theme_stylebox_override("fill", GREEN_BAR)
	
	# ATTACK POTION
	if Global.fireball_reload == "fireball_special":
		attackbar.add_theme_stylebox_override("fill", BLUE_BAR)
		if attack_potion_timer.is_stopped():
			attack_potion_timer.start()
	else:
		attackbar.add_theme_stylebox_override("fill", GREEN_BAR)
		
	# PLAYER HEALTHBAR
	if health != Global.player_health and is_instance_valid(healthbar):
			health = Global.player_health
			healthbar._set_health(health)
			
	#PLAYER DEATH
	elif health <= 0 and dead == false:
		dead = true
		if not Global.fall_death:
			get_tree().call_group("player", "death")
			death_timer.start()
		else:
			_on_death_timer_timeout()
		
		
	#ATTACK
	if Input.is_action_just_pressed("attack") and Global.can_attack and Global.can_move:
		attackbar.attack(Global.fireball_reload)
		get_tree().call_group("player", "attack")
	
	# UPDATING SCORE LABEL
	score.text = str(Global.coins)
	score_silver.text = str(Global.silver_coins)
	

func time(paused):
	if paused:
		time_label.visible = true
		time_label.text = str(Global.level_time)
	else:
		time_label.visible = false
		

func _on_dash_potion_timer_timeout() -> void:
	Global.dash_cooldown = cooldown

func _on_attack_potion_timer_timeout() -> void:
	Global.fireball_reload = attack


func load_data():
	var data = SaveManager.load_section("global_upgrade_data")
	Global.max_player_health = data.get("max_player_health", 100)
	Global.dash_damage = data.get("dash_damage", 15)
	Global.dash_cooldown = data.get("dash_cooldown", "dash_lvl1")
	Global.fireball_damage = data.get("fireball_damage", 10)
	Global.fireball_reload = data.get("fireball_reload", "fireball_lvl1")
	Global.fireball_speed = data.get("fireball_speed", 3)
	
	cooldown = data.get("dash_cooldown", "dash_lvl1")
	attack = data.get("fireball_reload", "fireball_lvl1")


func _on_death_timer_timeout() -> void:
	dead = false
	Global.player_health = Global.max_player_health
	if CheckpointManager.current_checkpoint != null:
		TransitionScreen.transition_red()
		await TransitionScreen.on_transition_finished
		CheckpointManager.respawn_player()
		get_tree().call_group("player", "alive")
		health = Global.player_health
		healthbar._set_health(health)
	else:
		TransitionScreen.transition_red()
		await TransitionScreen.on_transition_finished
		get_tree().reload_current_scene()

func _on_picked_up_butt_pressed() -> void:
	if Global.picked == "dash":
		Global.picked = null
		Global.dash_cooldown = "dash_special"
	if Global.picked == "attack":
		Global.picked = null
		Global.fireball_reload = "fireball_special"
	if Global.picked == "heal":
		Global.picked = null
		if Global.max_player_health > Global.player_health:
				if (Global.max_player_health - Global.player_health) < 50:
					Global.player_health = Global.max_player_health
					get_tree().call_group("player", "health_heal", -1)
				else:
					Global.player_health += 50
					get_tree().call_group("player", "health_heal", 50)
