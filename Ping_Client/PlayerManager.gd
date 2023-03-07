extends Node2D

signal ok_register_player
signal player_name

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func register_player(_name):
	if get_tree().get_network_peer() == null:
		return
		
	rpc_id(1, "register_player", _name)


puppet func response_register_player(msg) -> void:	
	emit_signal("ok_register_player", msg)



func get_player_name_from_id(id):
	rpc_id(1, "get_player_name_from_id", id)
	
	
puppet func response_get_player_name_from_id(id, _name):
	print(id, " asdas ", _name)
	emit_signal("player_name", id, _name)
