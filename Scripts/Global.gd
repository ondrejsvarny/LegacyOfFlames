extends Node

# for MOBILE
#func _enter_tree():
	#get_tree().root.max_size = Vector2i(1600, 720)
	#get_tree().root.min_size = Vector2i(1280, 720)

var menu_first_time = true
#@onready var timer = $dash_timer
var dashing = false
var can_dash = true

var coins = 0
var level_coins = 0
var silver_coins = 0
var level_silver_coins = 0

var player_health = 100
var can_move = true
var can_attack = true
var fall_death = false

var levels = [null,
	true,false,true,true,true,
	true,true,true,true,true,
]

var picked = null

var level_time
var current_level = 1
var pausable = true

var max_player_health = 100

var fireball_damage = 10
var fireball_speed = 3
var fireball_reload = "fireball_lvl1"

var dash_damage = 15
var dash_cooldown = "dash_lvl1"
