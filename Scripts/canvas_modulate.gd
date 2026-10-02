extends CanvasModulate

@onready var light: PointLight2D = $"../../Player/PointLight2D"
@onready var canvas_backgroud: CanvasModulate = $"../../Background/CanvasModulate"
@onready var score_silver: Label = %UI/%ScoreSilver
@onready var score: Label = %UI/%Score
@onready var time: Label = %UI/%TimeLabel
	
var fade_speed : float = 2.0

var target_color : Color = Color(1, 1, 1, 1) 
var target_label_color : Color = Color(0, 0, 0, 1) 
var target_energy: float = 0.0

func _process(delta):
	color = color.lerp(target_color, fade_speed * delta)
	if is_instance_valid(canvas_backgroud):
		canvas_backgroud.color = canvas_backgroud.color.lerp(target_color, fade_speed * delta)
	else:
		#print("Treba dat CanvasModulate pod Backgroud!!!")
		pass
	
	light.energy = lerp(light.energy, target_energy, fade_speed * delta)
	
	score.modulate = score.modulate.lerp(target_label_color, fade_speed * delta)
	score_silver.modulate = score_silver.modulate.lerp(target_label_color, fade_speed * delta)
	time.modulate = time.modulate.lerp(target_label_color, fade_speed * delta)

func _on_dark_off_body_entered(body: Node2D) -> void:
	if body is Player:
		target_color = Color(1, 1, 1, 1)
		target_energy = 0
		target_label_color = Color(0, 0, 0, 1)


func _on_dark_on_body_entered(body: Node2D) -> void:
	if body is Player:
		target_color = Color(0, 0, 0, 1)
		target_energy = 1
		target_label_color = Color(1, 1, 1, 1)
