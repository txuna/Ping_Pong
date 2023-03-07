extends Node

const PORT = 28960
const server_ip = "192.168.x.x"

var client = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# 기존에 연결이 되어 있을 경우 기존연결 끊고 재접속
func connect_server() -> void:
	client = NetworkedMultiplayerENet.new() 
	client.create_client(server_ip, PORT)
	get_tree().set_network_peer(client)
	
	
# close_connection()은 peer 객체에서 가져오는가?
func close_connect():
	pass
	#get_tree().close_connection()
