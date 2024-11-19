extends ProgressBar

# Dictionary to store attack types and their cooldown durations (in seconds)
var dash_cooldowns = {
	"dash_lvl1": 3.0
}

# Reference to Timer
@onready var recharge_timer: Timer = $Timer
@onready var recharge_bar: ProgressBar = $"."

var already_started = false

# Variables for recharge logic
var recharge_duration: float = 0.0

func _ready():
	recharge_bar.value = 100

# Function to handle attacking
func dash(dash_type: String):
	recharge_duration = dash_cooldowns[dash_type]
	start_recharge(recharge_duration)

func start_recharge(duration: float) -> void:
	recharge_timer.start(duration)  # Start the timer for the duration
	recharge_bar.value = 0  # Reset the bar value to 0
	recharge_bar.max_value = 100  # Set max value for the bar

func _process(delta: float):
	if not Global.can_dash and not already_started:
		dash(Global.dash_cooldown)
		already_started = true

	if not recharge_timer.is_stopped():
		# Calculate the percentage filled based on the time left on the timer
		var percentage_filled = (recharge_timer.time_left / recharge_duration) * 100
		recharge_bar.value = 100 - percentage_filled  # Update the bar to fill from 0 to 100


func _on_timer_timeout() -> void:
	Global.can_dash = true
	already_started = false
	recharge_bar.value = 100  # Reset the bar to fully charged when done
