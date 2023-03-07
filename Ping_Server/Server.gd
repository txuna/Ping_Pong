extends Node2D

onready var toggle_server_btn = $Control/Control/ToggleServerBtn
onready var log_container = $Control/ScrollContainer/VBoxContainer

var is_running = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().connect("network_peer_connected", self, "_player_connected") 
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")


func init_server() -> void:
	Global.init_setup()

func _on_ToggleServerBtn_pressed() -> void:
	if not is_running:
		if not Network.create_server():
			add_log("Server Can not start")
			return 
				
		toggle_server_btn.text = "SERVER STOP"
		# 서버 초기화 
		init_server()
		add_log("Server Start")
		
	else:
		Network.stop_server()
		toggle_server_btn.text = "SERVER START"
		add_log("Server Stop")
		
	is_running = not is_running


func _player_connected(id):
	var peer = get_tree().get_network_peer()
	var client_ip = peer.get_peer_address(id)
	var client_port = peer.get_peer_port(id)
	add_log("client connected IP : {ip} Port : {port} ID : {id}".format({
		"ip" : client_ip, 
		"port" : client_port, 
		"id" : id
	}))
	
	
# 플레이어가 접속을 끊을 떄 플레이어 리스트에서 삭제
# 1. 자신이 만든 방 삭제 
# 2. 현재 다른 플레이어와 대기중 및 플레이중이라면 플레이중인 다른 플레이어 해당 방에서 KICK 및 해당 방 삭제
func _player_disconnected(id):
	var world_instance = null
	var peer = get_tree().get_network_peer()
	var client_ip = peer.get_peer_address(id)
	var client_port = peer.get_peer_port(id)
	# 접속 플레이어 리스트에서 삭제 
	var world_manager = get_node("WorldManager")
	var worlds = get_node("Worlds")
	Global.remove_player(id)
			
	
	add_log("client disconnected IP : {ip} Port : {port} ID : {id}".format({
		"ip" : client_ip, 
		"port" : client_port, 
		"id" : id
	}))

	var room = Global.get_room_from_player_id(id)
	if room == null:
		return 	
	
	world_instance = worlds.get_node_or_null(str(room.index))
	if world_instance == null:
		return 
	
	# 혼자라면 
	if room.join_player.size() == 1:
		add_log("room is destroyed [{index}]-[{title}]".format({
			"index" : room.index, 
			"title" : room.title
		}))
		Global.remove_room(room.index)
		world_instance.queue_free()
		return 
	
	room.join_player.erase(id)
	add_log("player out in the room : [{title}] - [{id}]".format({
		"title" : room.title, 
		"id" : id
	}))
	# 해당 방의 owner라면 
	if id == room.owner:
		var player_id = room.join_player[0]
		add_log("room owner is changed [{title}] [{origin}] -> [{new}]".format({
			"title" : room.title, 
			"origin" : id, 
			"new" : player_id
		}))
		room.owner = player_id 
	
	for player_id in room.join_player:
		world_manager.player_out_from_room(player_id, id)
	
	var origin = room.status
	room.status = Global.BOARDING
	add_log("room status is changed [{title}] [{origin}]->[{new}]".format({
		"title" : room.title, 
		"origin" : origin, 
		"new" : room.status
	}))
	return 


func add_log(text: String) -> void:
	var log_label = load("res://LogText.tscn").instance()
	log_container.add_child(log_label)
	log_label.set_text(text)
	return






