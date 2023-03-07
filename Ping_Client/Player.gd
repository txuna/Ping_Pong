extends KinematicBody2D

export(int) var SPEED = 300

var other_player_velocity = Vector2() 
var other_player_global_position = Vector2()

var velocity = Vector2()
var player_manager = null

var can_fire = true 
var is_reload = false
var direction = Vector2()
var player_name = ""

onready var tween = $Tween
onready var reload_timer = $ReloadTimer
onready var bullet_position = $BulletPosition
onready var name_label = $NameLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	player_manager = Server.get_node("PlayerManager")
	name_label.text = player_name

func _physics_process(delta):
	if get_tree().get_network_peer() == null:
		return

	# my player
	if is_network_master():
		input_handler() 
		
		if Input.is_action_pressed("fire") and can_fire and not is_reload:
			fire()
			is_reload = true
			reload_timer.start()
		
	# other player
	else:
		if not tween.is_active():
			move_and_slide(velocity * SPEED)
		

func input_handler():
	velocity = Vector2() 
	if Input.is_action_pressed("up"):
		velocity.y -= 1
		direction = Vector2(0, -1)
		bullet_position.position = Vector2(0, -38)
		
	if Input.is_action_pressed("down"):
		velocity.y += 1
		direction = Vector2(0, 1)
		bullet_position.position = Vector2(0, 38)

	if Input.is_action_pressed("left"):
		velocity.x -= 1 
		direction = Vector2(-1, 0)
		bullet_position.position = Vector2(-38, 0)
		
	if Input.is_action_pressed("right"):
		velocity.x += 1
		direction = Vector2(1, 0)
		bullet_position.position = Vector2(38, 0)
		
	velocity = velocity.normalized()
	velocity = move_and_slide(velocity * SPEED)
	

# World에 데이터 전송
func fire():
	var world_node = get_parent()
	if world_node == null:
		return
	
	world_node.create_bullet(direction, bullet_position.global_position) 
	
	
func set_other_player(_velocity, _global_position):
	tween.interpolate_property(self, "global_position", global_position, _global_position, 0.1)
	velocity = _velocity
	tween.start() 


func _on_ReloadTimer_timeout():
	is_reload = false
	
	
func setup_name(name):
	name_label.text = name
