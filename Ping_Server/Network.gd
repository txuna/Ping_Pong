extends Node

const PORT = 28960 
const MAX_CLIENT = 6

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func create_server() -> bool:
	var peer = NetworkedMultiplayerENet.new() 
	var err = peer.create_server(PORT, MAX_CLIENT)
	if err != OK:
		print("Create Server Error : ", err)
		return false
		
	get_tree().set_network_peer(peer)
	return true


# 모든 player 불러와서 kick rpc전송 - 클라이언트는 close_connection 호출 그후 서버는 network_peer = null
func stop_server() -> void: 
	# ... 
	get_tree().network_peer = null
