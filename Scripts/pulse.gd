extends Node2D

@export var pulse_time: float = 3.0
@export var initial_delay: float = 0.0  # Nový parameter pre oneskorenie

@onready var pulse: AnimatedSprite2D = $Pulse
@onready var area: Area2D = $Area2D

var is_dangerous: bool = false
const DAMAGE = 30

func _ready() -> void:
	set_safe_state()
	start_pulse()

func start_pulse() -> void:
	# Čakáme na počiatočné oneskorenie
	await get_tree().create_timer(initial_delay).timeout
	
	# Hlavný cyklus pulzovania
	while true:
		await get_tree().create_timer(pulse_time).timeout
		toggle_state()

func toggle_state() -> void:
	is_dangerous = !is_dangerous
	if is_dangerous:
		set_dangerous_state()
	else:
		set_safe_state()

func set_safe_state() -> void:
	area.monitoring = false 
	pulse.play("harmless_pulse")

func set_dangerous_state() -> void:
	area.monitoring = true
	pulse.play("killing_pulse")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and Global.dashing:
		Global.player_health -= DAMAGE
