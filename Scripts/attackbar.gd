extends ProgressBar

# Dictionary to store attack types and their cooldown durations (in seconds)
var attack_cooldowns = {
	"fireball_lvl1": 3.0,  
	"fireball_lvl2": 2.0,  
	"fireball_lvl3": 1.5, 
	"fireball_lvl4": 1.0,
	
	"heavy_lvl1": 3.0,  
	"heavy_lvl2": 3.0,
	"heavy_lvl3": 3.0,
	"heavy_lvl4": 3.0,
}

# Reference to Timer
@onready var recharge_timer: Timer = $Timer
@onready var recharge_bar: ProgressBar = $"."


# Variables for recharge logic
var recharge_duration: float = 0.0

func _ready():
	recharge_bar.value = 100

# Function to handle attacking
func attack(attack_type: String):
	if Global.can_attack and attack_cooldowns.has(attack_type):
		#Global.can_attack = false

		# Start cooldown based on attack type
		recharge_duration = attack_cooldowns[attack_type]
		start_recharge(recharge_duration)

func start_recharge(duration: float) -> void:
	recharge_timer.start(duration)  # Start the timer for the duration
	recharge_bar.value = 0  # Reset the bar value to 0
	recharge_bar.max_value = 100  # Set max value for the bar

func _process(delta: float):
	if not recharge_timer.is_stopped():
		# Calculate the percentage filled based on the time left on the timer
		var percentage_filled = (recharge_timer.time_left / recharge_duration) * 100
		recharge_bar.value = 100 - percentage_filled  # Update the bar to fill from 0 to 100


func _on_timer_timeout() -> void:
	Global.can_attack = true  # Allow attacking again
	recharge_bar.value = 100  # Reset the bar to fully charged when done
