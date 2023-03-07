extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


master func get_room_list():
	var room_list = Global.get_room_list()
	var sender_id = get_tree().get_rpc_sender_id() 
	rpc_id(sender_id, "response_get_room_list", room_list)

	
master func join_room(index):	
	var flag = false 
	var server_node = get_parent()
	var sender_id = get_tree().get_rpc_sender_id() 
	var room = Global.get_room_from_index(index)
	
	if room == null:
		rpc_id(sender_id, "response_join_room", {
			"status" : false, 
			"msg" : "Isn't Exist Room"
		})
		server_node.add_log("Failed join room : {msg}-{id}".format({"msg" : "Isn't Exist Room", "id" : sender_id}))
		return 
	
	if room.join_player.size() >= 2:
		rpc_id(sender_id, "response_join_room", {
			"status" : false, 
			"msg" : "Already Full...!"
		})
		server_node.add_log("Failed join room : {msg}-{id}".format({"msg" : "Already Full...!", "id" : sender_id}))
		return 
		
	Global.join_player_in_room(index, sender_id)
	rpc_id(sender_id, "response_join_room", {
		"status" : true, 
		"msg" : "Success"
	})
	# 방장 클라이언트에게 참여했다고 전송 
	rpc_id(room.owner, "response_other_player_join_this_room", sender_id)	
	# 자신에게도 방장이 접속한거처럼 보이게 하기
	rpc_id(sender_id, "response_other_player_join_this_room", room.owner)
	server_node.add_log("Success join room : {id}".format({"id" : sender_id}))
	return


master func create_room(title):
	var msg = {}
	var sender_id = get_tree().get_rpc_sender_id()
	var server_node = get_parent()
	
	# 생성할 수 있는 방의 갯수를 초가할 때 
	if not Global.get_room_list().size() < Global.MAX_ROOM_COUNT:
		rpc_id(sender_id, "response_create_room", {
			"status" : false, 
			"msg" : "Can't create room anymore"
		})
		server_node.add_log("Failed create room : {msg}-{id}".format({"msg" : "Can't create room anymore", "id" : sender_id}))
		return 	
	
	# 제목이 존재 하지 않을 때 
	if title == "":
		rpc_id(sender_id, "response_create_room", {
			"status" : false, 
			"msg" : "Invalid Title or User"
		})
		server_node.add_log("Failed create room : {msg}-{id}".format({"msg" : "Invalid Title or User", "id" : sender_id}))
		return 
	
	# 중복적인 이름을 가진 바이나 owner가 같은 방 또는 만들려는 id가 이미 소속된 id라면 
	var room_list = Global.get_room_list() 
	for room in room_list:
		if title == room.title or sender_id == room.owner or sender_id in room.join_player:
			rpc_id(sender_id, "response_create_room", {
				"status" : false, 
				"msg" : "Already used Title or User"
			})
			server_node.add_log("Failed create room : {msg}-{id}".format({"msg" : "Already used Title or User", "id" : sender_id}))
			return 
	
	var index = Global.make_room_index()
	# 사용가능한 인덱스가 없을 때 
	if index == -1:
		rpc_id(sender_id, "response_create_room", {
			"status" : false, 
			"msg" : "Failed create room : {msg}-{id}".format({"msg" : "All indexes are used", "id" : sender_id})
		})
		server_node.add_log("Failed create room : {msg}-{id}".format({"msg" : "All indexes are used", "id" : sender_id}))
		return 
		
	# 성공적으로 방이 생성됨
	Global.append_room({
		"index" : index,
		"title" : title, 
		"owner" : sender_id, 
		"status" : Global.BOARDING, 
		"join_player" : [sender_id]
	})
	
	# Worlds에 WOrld 추가 
	var worlds_node = get_parent().get_node("Worlds")
	var world_instance = load("res://World.tscn").instance() 
	world_instance.set_name(str(index))
	world_instance.setup(index)
	worlds_node.add_child(world_instance)
	
	rpc_id(sender_id, "response_create_room", {
		"status" : true, 
		"msg" : "Success"
	})
	server_node.add_log("Success create room - {id}".format({"id" : sender_id}))
	return 
	
	

	
	
	
	
