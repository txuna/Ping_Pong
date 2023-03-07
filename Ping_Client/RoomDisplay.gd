extends Control


onready var info_label = $InfoLabel
onready var status_label = $StatusLabel

var room_info = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# msg - index, title, status, owner id, players id(list)
# status 1(boarding), 2(ready), 3(running)  
func set_text(index, title, owner, status) -> void:
	info_label.text = "[{index}] [{title}] [{owner}]".format({
		"index" : index, 
		"title" : title, 
		"owner" : owner
	})
	
	room_info.index = index 
	room_info.title = title 
	room_info.owner = owner 
	room_info.status = status 
	status_label.text = "[{status}]".format({"status" : status})


func _on_JoinRoomBtn_pressed():
	var room_manager = Server.get_node("RoomManager") 
	room_manager.join_room(room_info.index)



