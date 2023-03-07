extends Control

onready var name_field = $NameFIeld 
onready var connect_server_btn = $ConnectServerBtn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().connect("connected_to_server", self, "_connected_to_server")


func _on_ConnectServerBtn_pressed() -> void:
	if name_field.text == "":
		return 
	Network.connect_server()


func _connected_to_server():
	var player_manager = Server.get_node("PlayerManager")
	player_manager.connect("ok_register_player", self, "_ok_register_player")
	if player_manager == null:
		return 
	player_manager.register_player(name_field.text)


func _ok_register_player(msg):
	if not msg.status:
		Global.popup_alert(msg.msg)
		return 
	get_tree().change_scene("res://Rooms.tscn")
