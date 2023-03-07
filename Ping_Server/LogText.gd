extends Control


onready var log_label = $Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func set_text(_text: String) -> void:
	var timeDict = OS.get_time()
	var hour = timeDict.hour
	var minute = timeDict.minute
	var second = timeDict.second
	
	log_label.text = "[" + str(hour) + ":" + str(minute) + ":" + str(second) + "] " + _text
