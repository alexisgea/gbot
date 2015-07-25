
extends RigidBody2D

# we use the script written by our friend
var input_states = preload("res://bot/action_script.gd")

export var player_speed = 200
export var acceleration = 5
export var extra_gravity = 300
export var jumpforce = 200

var raycast_down = null

var current_speed = Vector2(0,0)

var key_r = input_states.new("key_r")
var key_l = input_states.new("key_l")
var key_j = input_states.new("key_j")

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
	raycast_down = get_node("RayCast2D")
	raycast_down.add_exception(self)
	
	set_fixed_process(true)
	set_applied_force(Vector2(0,extra_gravity))
	
	
func _fixed_process(delta):
	
	# old stuff for info, remove .check() below to use
	#key_r = Input.is_action_pressed("key_r")
	
	if key_r.check() == 2:
		move(player_speed,acceleration, delta)
	elif key_l.check() == 2:
		move(-player_speed,acceleration, delta)
	else:
		move(0,acceleration, delta)
	
	if is_on_ground():
		if key_j.check() == 1:
			set_axis_velocity(Vector2(0,-jumpforce))
		