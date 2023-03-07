extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# 플레이어로부터 데이터를 받아오면 Worlds-World(index)-[player_id, other_id] 이런식으로 구조됨
# 받으면 상대방 other_id에게 전송
# sender_id가 몇번 index world에 속해있는지 확인 필요
master func player_move_tick(_velocity, _global_position):
	var sender_id = get_tree().get_rpc_sender_id() 
	var worlds = get_parent().get_node("Worlds")
	var players = []
	for world in worlds.get_children():
		var room_info = world.room_info 
		if sender_id in room_info.join_player:
			players = room_info.join_player
			break 
	
	for player_id in players:
		if sender_id != player_id:
			# 현재 연결된 peer라면
			if player_id in get_tree().multiplayer.get_network_connected_peers():
				rpc_id(player_id, "set_other_player_move_tick", _velocity, _global_position, sender_id)
				break 			


master func create_bullet(_velocity, _global_position):
	var sender_id = get_tree().get_rpc_sender_id()
	var worlds = get_parent().get_node("Worlds")
	var players = []
	for world in worlds.get_children():
		var room_info = world.room_info 
		if sender_id in room_info.join_player:
			players = room_info.join_player
			break 
	
	for player_id in players:
		if sender_id != player_id:
			# 현재 연결된 peer라면
			if player_id in get_tree().multiplayer.get_network_connected_peers():
				rpc_id(player_id, "response_create_bullet", _velocity, _global_position, sender_id)
				break 	
	

func player_out_from_room(player_id, out_id):
	rpc_id(player_id, "response_player_out", out_id)
	



