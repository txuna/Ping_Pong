extends Control



onready var room_container = $VBoxContainer
onready var create_room_control = $CreatRoomControl

var room_manager = null
const STATUS = ["Boarding", "Ready", "Running"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	room_manager = Server.get_node("RoomManager")
	room_manager.connect("ok_get_room_list", self, "_ok_get_room_list")
	room_manager.connect("ok_join_room", self, "_ok_join_room")
	append_room()


func append_room() -> void:
	for n in room_container.get_children():
		room_container.remove_child(n)
		n.queue_free()
	room_manager.get_room_list() 
	

func _ok_get_room_list(room_list):
	for room in room_list:
		var room_display = load("res://RoomDisplay.tscn").instance() 
		room_container.add_child(room_display)
		# get owner from id 
		room_display.set_text(room.index, room.title, room.owner, STATUS[room.status])


func _ok_join_room(msg):
	if not msg.status:
		Global.popup_alert(msg.msg)
		return 
	
	get_tree().change_scene("res://World.tscn") 


func _on_ReloadRoom_timeout() -> void:
	append_room()


func _on_CreateRoomBtn_pressed():
	create_room_control.visible = true
