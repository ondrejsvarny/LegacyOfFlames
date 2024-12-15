extends Area2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var timer = $Timer

var collected = false
var coin_id

func _ready() -> void:
	coin_id = str(global_position.x) + str(global_position.y)
	load_data()
	if collected:
		queue_free()

func _on_body_entered(body):
	Global.silver_coins += 1
	Global.level_silver_coins += 1
	set_collision_mask_value(2,0)
	animated_sprite.play("collected")
	timer.start()
	collected = true
	save()

func _on_timer_timeout():
	queue_free()
	
func save():
	var data = {
		"collected": collected,
	}
	SaveManager.save_section("coin_" + coin_id, data)
	
	var currencies = {
		"coins": Global.coins,
		"silver_coins": Global.silver_coins
	}
	SaveManager.save_section("global_currencies", currencies)

func load_data():
	var data = SaveManager.load_section("coin_" + coin_id)
	collected = data.get("collected", false)
	
