extends Node2D

func _ready():
#	self._debug_kennel_sprit()
	Global.connect("newAnimal", setup_kennels)
	self.setup_kennels()

func setup_kennels():
	var kenstr = "Kennel%s"
	for key in Global.current_animals.keys():
		if self.has_node(kenstr % key):
			var node = kenstr % key
			get_node(node).update_animal(Global.current_animals[key])
	
func _kennel_clicked(node):
	if not node.empty:
		Global.active_animal['name'] = node.animalName
		Global.active_animal['type'] = node.type
		Global.active_animal['adoptability'] = node.adoptability
		Global.active_animal['health'] = node.health
		Global.active_animal['thirst'] = node.thirst
		Global.active_animal['hunger'] = node.hunger
		Global.active_animal['happiness'] = node.happiness
		Global.active_animal['toy'] = node.toy
		
		Global.active_kennel = node.KennelNo
		Global.goto_scene("res://animals/animal_view.tscn")
	else:
		print("empty kennel")

