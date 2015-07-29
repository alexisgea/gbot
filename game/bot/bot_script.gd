
extends RigidBody2D

# we use the script written by our friend
var input_states = preload("res://bot/action_script.gd")

export var player_speed = 200
export var acceleration = 5
export var air_acceleration = 2
export var extra_gravity = 300
export var jumpforce = 200

var PLAYERSTATE_PREV = ""
var PLAYERSTATE = ""
var PLAYERSTATE_NEXT = "ground"

var ORIENTATION_PREV = ""
var ORIENTATION = ""
var ORIENTATION_NEXT = "right"

var raycast_down = null

var current_speed = Vector2(0,0)

var rotate = null
var jumping = null

var key_r = input_states.new("key_r")
var key_l = input_states.new("key_l")
var key_j = input_states.new("key_j")

var anim_player = null
var anim = ""
var anim_new = ""
var anim_speed = 1.0
var anim_blend = 0.2


# it use to be the below for info
#var key_j = Input.is_action_pressed("key_j")


func move(speed, accel, delta):
	# makes movement smooth	
	current_speed.x = lerp(current_speed.x, speed, accel * delta)
	set_linear_velocity(Vector2(current_speed.x,get_linear_velocity().y))


func is_on_ground():
	if raycast_down.is_colliding():
		return true
	else:
		return false


func _ready():
	get_node("Camera2D").set_zoom(get_node("Camera2D").get_zoom() * get_node("/root/global").viewport_scale)

	raycast_down = get_node("RayCast2D")
	raycast_down.add_exception(self)
	
	rotate = get_node("rotate")
	
	set_fixed_process(true)
	set_applied_force(Vector2(0,extra_gravity))
	
	anim_player = get_node("rotate/bot_sprite/AnimationPlayer")	
	
	
func rotate_behavior():
	if (ORIENTATION == "right" and ORIENTATION_NEXT == "left") or (ORIENTATION == "left" and ORIENTATION_NEXT == "right"):
		rotate.set_scale(rotate.get_scale() * Vector2(-1,1))
	
	
func _fixed_process(delta):

	PLAYERSTATE_PREV = PLAYERSTATE
	PLAYERSTATE = PLAYERSTATE_NEXT
	
	ORIENTATION_PREV = ORIENTATION
	ORIENTATION = ORIENTATION_NEXT
	
	if PLAYERSTATE == "ground":
		ground_state(delta)
	elif PLAYERSTATE == "air":
		air_state(delta)
		
	if anim != anim_new:
		anim_new = anim
		anim_player.play(anim,anim_blend,anim_speed)


func ground_state(delta):
	
	if key_r.check() == 2:
		move(player_speed,acceleration, delta)
		ORIENTATION_NEXT = "right"
		anim_speed = 1.5
		anim_blend = 0.2
		anim = "run"
	elif key_l.check() == 2:
		move(-player_speed,acceleration, delta)
		ORIENTATION_NEXT = "left"
		anim_speed = 1.5
		anim_blend = 0.2
		anim = "run"
	else:
		move(0,acceleration, delta)
		anim_speed = 0.5
		anim_blend = 0.2
		anim = "rest"
		
	rotate_behavior()
	
	if is_on_ground():
		if key_j.check() == 1:
			set_axis_velocity(Vector2(0,-jumpforce))
			jumping = 1
	else:
		PLAYERSTATE_NEXT = "air"


func air_state(delta):
	
	if key_r.check() == 2:
		move(player_speed,air_acceleration, delta)
		ORIENTATION_NEXT = "right"
	elif key_l.check() == 2:
		move(-player_speed,air_acceleration, delta)
		ORIENTATION_NEXT = "left"
	else:
		move(0,air_acceleration, delta)
		
	if get_linear_velocity().y > 0:
		anim_speed = 1.0
		anim_blend = 0.2
		anim = "fall"
	else:
		anim_speed = 1.0
		anim_blend =0.0
		anim = "jump"
		
	rotate_behavior()
	
	if key_j.check() == 1 and jumping == 1:
			set_axis_velocity(Vector2(0,-jumpforce))
			jumping += 1
	
	if is_on_ground():
		#anim_speed = 0.5
		#anim_blend = 0.5
		#anim = "land2"
		PLAYERSTATE_NEXT = "ground"