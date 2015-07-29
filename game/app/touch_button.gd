
extends CanvasLayer

func _ready():
	get_node("left_side").set_pos(Vector2(0,get_node("/root/global").viewport_res.y))
	get_node("left_side").set_scale(get_node("left_side").get_scale() / get_node("/root/global").viewport_scale)
	
	get_node("right_side").set_pos(get_node("/root/global").viewport_res)
	get_node("right_side").set_scale(get_node("right_side").get_scale() / get_node("/root/global").viewport_scale)
