extends Node2D

signal kicked_room
signal other_player_move
signal other_bullet
signal out_player
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


puppet func kicked_from_room():
	emit_signal("kicked_room")


func send_player_move_tick(_velocity, _global_position):
	if get_tree().get_network_peer() == null:
		return 
		
	rpc_id(1, "player_move_tick", _velocity, _global_position)


puppet func set_other_player_move_tick(_velocity, _global_position, other_player_id):
	emit_signal("other_player_move", _velocity, _global_position, other_player_id)


func create_bullet(_velocity, _global_position):
	rpc_id(1, "create_bullet", _velocity, _global_position)
	

# 응답이 오면 상대방에게도 보이게 설정
puppet func response_create_bullet(_velocity, _global_position, sender_id):
	emit_signal("other_bullet", sender_id, _velocity, _global_position)


puppet func response_player_out(out_id):
	emit_signal("out_player", out_id)






