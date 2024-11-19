extends Node

#@onready var timer = $dash_timer
var dashing = false
var can_dash = true

var coins = 150
var level_coins = 0
var player_health = 100
var can_move = true
var can_attack = true

var current_level = 0
var pausable = true

var max_player_health = 100
var dash_cooldown = "dash_lvl1"

var fireball_damage = 10
var fireball_speed = 3
var fireball_reload = "fireball_lvl1"

var attack2 = "heavy_lvl2"
