extends Control

var room_manager = null

onready var title_label = $TitleLineEdit

# Called when the node enters the scene tree for the first time.
func _ready():
	room_manager = Server.get_node("RoomManager")
	room_manager.connect("ok_create_room", self, "_ok_create_room")


func _on_ClosePanelBtn_pressed():
	visible = false


# send room info -> server
func _on_CreateRoomBtn_pressed():
	if title_label.text == "":
		return 
		
	room_manager.create_room(title_label.text)


# room manager emit signal to here! 
# status 값에 따라 alert_popup 활성화 결정 
func _ok_create_room(msg):
	if not msg.status:
		Global.popup_alert(msg.msg)
		return 
		
	visible = false
	get_tree().change_scene("res://World.tscn")








