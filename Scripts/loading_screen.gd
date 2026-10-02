extends Control

var progress = []
var sceneName
var load_status = 0
var loaded = false
@onready var count: Label = $Count

func _ready() -> void:
	sceneName = "res://Scenes/Levels/level_"+ str(Global.current_level)  +".tscn"
	ResourceLoader.load_threaded_request(sceneName)
	
func _process(delta: float) -> void:
	if not loaded:
		load_status = ResourceLoader.load_threaded_get_status(sceneName, progress)
		count.text = str(int(progress[0]*100)) + "%"
		
		if load_status == ResourceLoader.THREAD_LOAD_LOADED:
			loaded = true
			var newScene = ResourceLoader.load_threaded_get(sceneName)
			TransitionScreen.transition()
			await TransitionScreen.on_transition_finished
			get_tree().change_scene_to_packed(newScene)
