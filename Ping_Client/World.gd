extends Node2D


# player와 상대방 플레이어 정보 받아오기 

var player_id = -1
var world_manager = null
var player_manager = null

# Called when the node enters the scene tree for the first time.
func _ready():
	var room_manager = Server.get_node("RoomManager")
	var player = load("res://Player.tscn").instance() 
	
	player_manager = Server.get_node("PlayerManager")
	world_manager = Server.get_node("WorldManager")
	player_id = get_tree().get_network_unique_id()
	player_manager.connect("player_name", self, "_on_player_name")
	room_manager.connect("other_player_join", self, "_on_other_player_join")
	world_manager.connect("kicked_room", self, "_on_kicked_room")
	world_manager.connect("other_player_move", self, "_on_other_player_move")
	world_manager.connect("other_bullet", self, "_on_create_other_player_bullet")
	world_manager.connect("out_player", self, "_on_out_player")
	player.set_name(str(player_id))
	player.set_network_master(player_id)
	add_child(player)
	player_manager.get_player_name_from_id(player_id)
	randomize()
	player.global_position = Vector2(rand_range(0, 1024), rand_range(0, 600))
	

func _process(delta):
	pass
	
	
func _on_kicked_room():
	get_tree().change_scene("res://Rooms.tscn")


# 서버로 네트워크 전송? velocity, global_position 전송
# 다른 플레이어가 자신을 건들였을 때는? 
func _on_NetworkWorldTimer_timeout():
	var player_node = get_node(str(player_id))
	var player_velocity = player_node.velocity 
	var player_global_position = player_node.global_position
	world_manager.send_player_move_tick(player_velocity, player_global_position)


func _on_other_player_join(other_player_id):
	var other_player_instance = load("res://Player.tscn").instance() 
	other_player_instance.set_name(str(other_player_id))
	other_player_instance.set_network_master(other_player_id)
	add_child(other_player_instance)
	randomize()
	other_player_instance.global_position = Vector2(rand_range(0, 1024), rand_range(0, 600))
	yield(get_tree().create_timer(0.1), "timeout")
	player_manager.get_player_name_from_id(other_player_id)
	
	
func _on_other_player_move(_velocity, _global_position, _id):
	var other_player_node = get_node_or_null(str(_id))
	# null이라면 아직생성중이거나 disconnected되었거나 없거나 등등 ...
	if other_player_node == null:
		return 
	other_player_node.set_other_player(_velocity, _global_position)
		

func create_bullet(_velocity, _global_position):
	world_manager.create_bullet(_velocity, _global_position)
	var bullet = load("res://Bullet.tscn").instance() 
	add_child(bullet)
	bullet.setup(_velocity, _global_position) 
	bullet.set_name(str(player_id))
	bullet.set_network_master(player_id)
	
	
func _on_create_other_player_bullet(sender_id, _velocity, _global_position):
	var bullet = load("res://Bullet.tscn").instance() 
	add_child(bullet)
	bullet.setup(_velocity, _global_position)
	bullet.set_name(str(sender_id))
	bullet.set_network_master(sender_id)


func _on_player_name(id, name):
	var player = get_node_or_null(str(id))
	if player == null:
		return 
		
	player.setup_name(name)
	

func _on_out_player(out_id):
	var player_node = get_node_or_null(str(out_id))
	if player_node == null:
		return 
		
	player_node.queue_free()
	
	
	
