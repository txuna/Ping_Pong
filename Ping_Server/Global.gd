extends Node

const BOARDING = 0 
const READY = 1
const RUNNING = 2

const MAX_ROOM_COUNT = 10

"""
player list data structure 
플레이어가 어느 방에 있는지도 추가해야하는가 - 어디에 ? 
player_list = [
	{
		"id" : id, 
		"name" : name
	}
]
"""

var player_list = [] 

"""
room_list = {
		"title" : id, 
		"index" : index, 
		"owner" : id, 
		"status" : status,  0 1 2
		"join_player" : [] # id 
		""
},
"""
var room_list = []


func init_setup():
	player_list = [] 
	room_list = []

func get_player_list() -> Array:
	return player_list 
	
	
func get_player(id) -> Dictionary: 
	for player in player_list:
		if player.id == id:
			return player 
	return {}
	
	
	
func append_player(_id, _name) -> void:
	player_list.append({
		"id" : _id, 
		"name" : _name
	})
	return 


# 참여하고 있는 player id로 방 확인 
func get_room_from_player_id(id):
	for room in room_list:
		if id in room.join_player:
			return room
	return null
	

func out_player_in_room(id):
	var room = get_room_from_player_id(id)
	if id in room.join_player:
		room.join_player.erase(id)
	

# 플레이어 뿐만 아니라 참여하고 있는 방도 확인
func remove_player(_id) -> void:
	var player = get_player(_id)
	if player == {}:
		return 
	player_list.erase(player)

			
func get_owner_room(id):
	for room in room_list:
		if id == room.owner:
			return room
	return null
	

func get_join_room(id):
	for room in room_list:
		if id in room.join_player:
			return room
	return null

# 동일한 닉네임의 플레이어가 존재하는지 확인 있다면 false를 리턴하여 rpc(_id, "kick_player") 
func verify_player(_id, _name) -> bool:
	if _name == "":
		return false
		
	for player in player_list:
		if player.name == _name or player.id == _id:
			return false
	
	return true 


# 방제목이 이미 존재하는지 등등 알림 확인 있다면 false를 리턴하여 rpc(_id, "retry_create_room") 
func verify_room(_id, _title) -> bool:
	for room in room_list:
		if room.title == _title:
			return false 
	return true


func append_room(room) -> void:
	room_list.append(room)
	

func remove_room(index):
	var room = get_room_from_index(index)
	if room == null:
		return 
	room_list.erase(room)
	

func get_room_list():
	return room_list


func make_room_index():
	var flag = false 
	
	for index in range(1, 11, 1):
		for room in room_list:
			if index == room.index:
				flag = true 
				break 
				
		if not flag:
			return index 
		else:
			flag = false
		
	# 모든 index를 사용하고 있을 때 
	return -1


func get_room_from_index(index):
	for room in room_list:
		if index == room.index:
			return room 
			
	return null


func get_room_player_from_index(index):
	for room in room_list:
		if index == room.index:
			return room.join_player
	return [] 


func join_player_in_room(index, player_id):
	var room = get_room_from_index(index)
	room.join_player.append(player_id) 
	if room.join_player.size() >= 2:
		room.status = READY

