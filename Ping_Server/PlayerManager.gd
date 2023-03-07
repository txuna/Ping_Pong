extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


master func get_player_name_from_id(id):
	var sender_id = get_tree().get_rpc_sender_id()
	var player = Global.get_player(id)
	rpc_id(sender_id, "response_get_player_name_from_id", id, player.name)


# 성공적일때 Token 발행  - 추후 추가
master func register_player(name):
	var sender_id = get_tree().get_rpc_sender_id()
	var msg = {}
	var server_node = get_parent()
	
	if not Global.verify_player(sender_id, name):
		msg.status = false 
		msg.msg = "Invalid username"
	else:
		msg.status = true 
		msg.msg = "Success"
	
	if msg.status:
		Global.append_player(sender_id, name)
	
	server_node.add_log("[{status}] register player({_id})-({name})-({msg})".format({
		"_id" : sender_id, 
		"name" : name, 
		"status" : msg.status, 
		"msg" : msg.msg}))
	rpc_id(sender_id, "response_register_player", msg)
