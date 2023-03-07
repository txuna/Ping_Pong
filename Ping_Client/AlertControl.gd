extends Control

onready var label = $Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func popup(_text):
	label.text = _text 
	visible = true


func _on_Button_pressed() -> void:
	queue_free()
