extends Node2D

signal ok_get_room_list
signal ok_create_room
signal ok_join_room
signal other_player_join

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func get_room_list():
	if get_tree().get_network_peer() == null:
		return
	rpc_id(1, "get_room_list")


puppet func response_get_room_list(room_list) -> void:
	emit_signal("ok_get_room_list", room_list)


func join_room(room_index):
	if get_tree().get_network_peer() == null:
		return 
	rpc_id(1, "join_room", room_index)
	

puppet func response_join_room(msg):
	emit_signal("ok_join_room", msg)
	

# 상대방이 접속했을 때 
puppet func response_other_player_join_this_room(other_player_id):
	# 시그널 연결을 위한 대기 시간
	yield(get_tree().create_timer(0.5), "timeout")
	emit_signal("other_player_join", other_player_id)


func create_room(title):
	if get_tree().get_network_peer() == null:
		return
	rpc_id(1, "create_room", title)
	
	
puppet func response_create_room(msg):
	emit_signal("ok_create_room", msg)

