extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func popup_alert(msg):
	var popup = load("res://AlertControl.tscn").instance() 
	var root_node = get_node("root")
	root_node.add_child(popup)
	popup.popup(msg)
