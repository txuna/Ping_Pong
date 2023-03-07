extends Node


# RPC로 인한 서버와 통신하기 위한 노드 - 이름 같아야 함


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player_manager = load("res://PlayerManager.tscn").instance() 
	var room_manager = load("res://RoomManager.tscn").instance() 
	var world_manager = load("res://WorldManager.tscn").instance() 
	
	add_child(room_manager)
	add_child(player_manager)
	add_child(world_manager)

