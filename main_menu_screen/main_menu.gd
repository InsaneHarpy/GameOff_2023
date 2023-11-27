extends Node2D

func _on_quit_pressed():
	get_tree().quit()

func _on_play_pressed():
	Global.goto_scene("res://kennel_room/kennel_room.tscn")


# handle scale visibility of selection
func _on_play_mouse_entered():
	get_node("Play/play_hover").visible = true
func _on_play_mouse_exited():
	get_node("Play/play_hover").visible = false
func _on_quit_mouse_entered():
	get_node("Quit/quit_hover").visible = true
func _on_quit_mouse_exited():
	get_node("Quit/quit_hover").visible = false
