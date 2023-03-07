extends Node2D

# 각 방마다 World를 만듦 
var room_info = {} # Global에 있는 값이 바껴도 같이 바껴야
var room_index = -1
var world_manager = null

# Called when the node enters the scene tree for the first time.
func _ready():
	world_manager = get_parent().get_parent().get_node("WorldManager")
	room_info = Global.get_room_from_index(room_index)
	
	
func setup(index):
	room_index = index


func _process(delta):
	pass
