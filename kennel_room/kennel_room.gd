extends Node2D
	
func _kennel_clicked(node):
	Global.active_animal['name'] = node.animalName
	Global.active_animal['type'] = node.type
	Global.active_animal['kennel'] = node.KennelNo
	Global.active_animal['adoptability'] = node.adoptability
	Global.active_animal['health'] = node.health
	Global.active_animal['thirst'] = node.thirst
	Global.active_animal['hunger'] = node.hunger
	Global.active_animal['happiness'] = node.happiness
	Global.goto_scene("res://animals/animal_view.tscn")
