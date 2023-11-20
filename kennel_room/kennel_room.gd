extends Node2D

func _ready():
#	self._debug_kennel_sprit()
	self.setup_kennels()

func setup_kennels():
	var kenstr = "Kennel%s"
	for key in Global.current_animals.keys():
		if self.has_node(kenstr % key):
			var node = kenstr % key
			get_node(node).update_animal(Global.current_animals[key])

			

func _debug_kennel_sprit():
	get_node("Kennel1").update_animal('dragon')
	get_node("Kennel2").update_animal('dragon')
	get_node("Kennel3").update_animal('nine tailed fox')
	get_node("Kennel4").update_animal('test')	
	
func _kennel_clicked(node):
	if not node.empty:
		Global.active_animal['name'] = node.animalName
		Global.active_animal['type'] = node.type
		Global.active_animal['adoptability'] = node.adoptability
		Global.active_animal['health'] = node.health
		Global.active_animal['thirst'] = node.thirst
		Global.active_animal['hunger'] = node.hunger
		Global.active_animal['happiness'] = node.happiness
		
		Global.active_kennel = node.KennelNo
		Global.goto_scene("res://animals/animal_view.tscn")
	else:
		print("empty kennel")

