extends AnimatedSprite2D

@export var object_scene: PackedScene = null
@export_enum("basic", "black", "gold", "white", "basic_snow", "black_snow", "gold_snow", "white_snow") var look: String = "basic"

@onready var timer: Timer = $Timer
@onready var chest: AnimatedSprite2D = $"."


var is_opened = false
var chest_id

func _ready() -> void:
	chest_id = str(global_position.x) + str(global_position.y)
	load_data()
	if is_opened:
		chest.autoplay = ""
		chest.animation = look + "_open"
		chest.frame = 4
	else: 
		chest.play(look + "_idle")

func drop_object():
	var object: Node2D = object_scene.instantiate()
	add_child(object)
	
	object.set_collision_mask_value(2, false)

	# Create a tweener for moving the object upwards
	var tweener = create_tween()
	object.position = object.position + Vector2(-5, 0)
	var position = object.position
	tweener.tween_property(object, "position", position + Vector2(0, -5), 0.3)
	tweener.set_trans(Tween.TRANS_QUAD)
	tweener.set_ease(Tween.EASE_OUT)

	await tweener.finished

	# Create another tweener for moving the object back to its original position
	tweener = create_tween()
	tweener.tween_property(object, "position", position + Vector2(0, 8), 0.3)
	tweener.set_trans(Tween.TRANS_SINE)
	tweener.set_ease(Tween.EASE_IN)
	
	await tweener.finished
	
	object.set_collision_mask_value(2, true)



func _on_timer_timeout() -> void:
	drop_object()

func _on_area_2d_body_entered(body: Player) -> void:
	if not is_opened:
		chest.play(look + "_open")
		is_opened = true
		#save()
		timer.start()
		

func save():
	var data = {
		"is_opened": is_opened,
	}
	SaveManager.save_section("chest_" + chest_id, data)

func load_data():
	var data = SaveManager.load_section("chest_" + chest_id)
	is_opened = data.get("is_opened", false)
	
