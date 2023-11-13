extends Node2D

func _on_quit_pressed():
	get_tree().quit()

func _on_play_pressed():
	Global.goto_scene("res://kennel_room/kennel_room.tscn")
