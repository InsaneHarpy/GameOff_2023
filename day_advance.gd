extends Node2D

var animPart = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Counter").text = str(Global.daycount)
	get_node("Timer").wait_time = 2

func _on_timer_timeout():
	if animPart ==0:
		get_node("Counter").text = ""
		animPart += 1
	elif animPart == 1:
		Global.daycount += 1
		get_node("Counter").text = str(Global.daycount)
		animPart += 1
	else:
		Global.goto_scene("res://kennel_room/kennel_room.tscn")
