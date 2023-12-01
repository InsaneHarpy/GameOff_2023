extends Node

###### UTILS ########

var current_scene = null
var scene_path : String = ""
var prev_scene : String = "res://kennel_room/kennel_room.tscn"
var daycount : int = 1
var fade : bool = false

########## Kennel info #############

var active_kennel : int = -1
var active_animal = {}
var fullKennels = [1]#,2,3]
var maxKennels : int = 6

var current_animals = {1: {'name': 'Paparino',
						'type': 'Dragon',
						'adoptability': 65,
						'health': 10,
						'thirst': 10,
						'hunger': 10,
						'happiness': 10,
						'toy': ''}
#						2: {'name': 'Winnie',
#						   'type': 'Nine Tailed Fox',
#						   'adoptability': 75,
#						   'health': 25,
#						   'thirst': 10,
#						   'hunger': 10,
#						   'happiness': 0,
#						   'toy': ''},
#						3: {'name': 'Jabu',
#						   'type': 'Griffin',
#						   'adoptability': 75,
#						   'health': 25,
#						   'thirst': 10,
#						   'hunger': 10,
#						   'happiness': 0,
#						   'toy': ''}
						}

##### Animals that can be brought into shelter #######
var available_animals = {1: {},
						2: {},
						3: {}}			

######### Vars to hold random animal types and names #########

var name_array
var type_array

########## Player stats #########
var player_energy : int = 100
var player_money : int = 100
var selected_food : int = 1

var player_inventory = {'foodT1' : 0,
						'foodT2' : 0,
						'foodT3' : 0,
						'mouse' : 0,
						'bone' : 0,
						'yarn' : 0,
						'barley' : 0}

# amounts for interacting with animals in animal view
var pet_runaway_penalty : int = 20

var click_feed_petinc = {'foodT1': 10,
						'foodT2': 15,
						'foodT3': 30}
						
var click_feed_stamdec : int = 10

var click_water_petinc : int = 10
var click_water_stamdec : int = 10

var click_play_petinc : int = 10
var click_play_stamdec : int = 10

var toy_happiness_inc = {'mouse' : 5,
						'bone' : 10,
						'yarn' : 15,
						'barley' : 20}

##### Store Prices ######
var foodT1_price : int = 10
var foodT2_price : int = 20
var foodT3_price : int = 50
var mouse_price : int = 15
var bone_price : int = 30
var yarn_price : int = 50
var barley_price: int = 100

						
##### Animation handler #############

var animations = {'Dragon':'blue dragon',
				'Nine Tailed Fox': 'fox',
				'Griffin': 'gryphon'}
				
				
				
###### Signal managment ###########

signal scrollAnimal
signal newAnimal


# Called when the node enters the scene tree for the first time.
func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	
	# load in files to generate random names
	var f_names = FileAccess.open("res://animals/pet_names.txt", FileAccess.READ)
	var f_types = FileAccess.open("res://animals/pet_types.txt", FileAccess.READ)
	
	var t_names = f_names.get_as_text()
	var t_types = f_types.get_as_text()
	
	self.name_array = t_names.split("\n")
	self.type_array = t_types.split("\n")
	
	# when copying over from excel \r character was at the end of every line
	# Use this to sanatize weird characters that may be present in the strings
	for i in range(len(self.name_array)):
		if "\r" in self.name_array[i]:
			self.name_array[i] = self.name_array[i].replace("\r","")	
			
	for i in range(len(self.type_array)):
		if "\r" in self.type_array[i]:
			self.type_array[i] = self.type_array[i].replace("\r","")
		if "#" in self.type_array[i]: # cludgy way to remove unwanted types of animals
			self.type_array[i] = ""
	
	# remove empty strings from arrays (generally the enter at the end of the file)
	var sanatize = true
	while sanatize:
		var n_idx = self.name_array.find("")
		var t_idx = self.type_array.find("")
		if n_idx != -1:
			self.name_array.remove_at(n_idx)
		if t_idx != -1 :
			self.type_array.remove_at(t_idx)
		if n_idx == -1 and t_idx == -1:
			sanatize = false

func _process(delta):
	if self.player_energy  < 0:
		print_debug("player energy negative zero")
		self.player_energy = 0
	if self.player_energy > 100:
		self.player_energy = 100
#	if self.fade:
#		get_tree().current_scene.set_modulate(lerp(get_tree().current_scene.get_modulate(), Color(0,0,0,1), 0.2))
#		if get_tree().current_scene.get_modulate().is_equal_approx(Color(0,0,0,1)):
#			call_deferred("_deferred_goto_scene", self.scene_path)
#			self.fade = false
#			get_tree().current_scene.set_modulate(lerp(get_tree().current_scene.get_modulate(), Color(0,0,0,1), 0.2))

func generate_available_animals():
	randomize()
	for key in self.available_animals:
		self.available_animals[key]["name"] = self.name_array[randi()%len(self.name_array)]
		self.available_animals[key]["type"] = self.type_array[randi()%len(self.type_array)]
		self.available_animals[key]["adoptability"] = randi()%100 + 1
		self.available_animals[key]["health"] = randi()%100 + 1
		self.available_animals[key]["thirst"] = randi()%100 + 1
		self.available_animals[key]["hunger"] = randi()%100 + 1
		self.available_animals[key]["happiness"] = randi()%100 + 1
		self.available_animals[key]["toy"] = ""

func advance_day():
	randomize()
	
	# Get new available animals
	self.generate_available_animals()
	
	# Update values for current animals
	for key in self.current_animals:
#		print(self.current_animals[key])
		# Natural decay of thirst and hunger
		self.current_animals[key]['thirst'] -= randi()%10+1
		self.current_animals[key]['hunger'] -= randi()%10+1
		
		#########
		
		# put how health decreases based upon health and thirst values
		if self.current_animals[key]['thirst'] <= 25: # thirst very bad to be zero.
			self.current_animals[key]['health'] -= 10
		elif self.current_animals[key]['hunger'] <= 15: # hunger very bad to be zero
			self.current_animals[key]['health'] -=10
		
		#########
		
		# natrual declination of thirst and hunger
		elif (self.current_animals[key]['thirst'] < 75
			or self.current_animals[key]['hunger'] < 50):
				
			self.current_animals[key]['health'] -= randi()%10 +1
		
		#########
		
		# increase health because good thirst and hunger
		elif (self.current_animals[key]['thirst'] >=75
			and self.current_animals[key]['hunger'] >= 50):
				
			self.current_animals[key]['health'] += randi()%10 + 1
		
		#########
		
		# bad health conditions
		if self.current_animals[key]['health'] <= 0:
			self.current_animals[key]['hunger'] -= 25
			self.current_animals[key]['thirst'] -= 25
			self.current_animals[key]['happiness'] -= 50
			self.current_animals[key]['adoptability'] -= 10
		
		#########
		
		# all values good, increase happiness
		if (self.current_animals[key]['health'] >75 and 
			self.current_animals[key]['thirst'] >=75 and 
			self.current_animals[key]['hunger'] >= 50):
				
			self.current_animals[key]['happiness'] += randi()%10 + 1
		
		#########
		
		# check if pet has toy, increase happiness
		
		if self.current_animals[key]['toy'] != "":
			self.current_animals[key]['happiness'] += self.toy_happiness_inc[self.current_animals[key]['toy']]
		
		########
		
		# how does pet adoptability increase?
		if self.current_animals[key]['happiness'] > 75:
			self.current_animals[key]['adoptability'] += randi()%10 + 1
		
		#########
		
		# make sure stats are within acceptable bounds
		if self.current_animals[key]['thirst'] > 100:
			self.current_animals[key]['thirst'] = 100
		elif self.current_animals[key]['thirst'] < 0:
			self.current_animals[key]['thirst'] = 0
		if self.current_animals[key]['hunger'] > 100:
			self.current_animals[key]['hunger'] = 100
		elif self.current_animals[key]['hunger'] < 0:
			self.current_animals[key]['hunger'] = 0
		if self.current_animals[key]['health'] > 100:
			self.current_animals[key]['health'] = 100
		elif self.current_animals[key]['health'] < 0:
			self.current_animals[key]['health'] = 0
		if self.current_animals[key]['happiness'] > 100:
			self.current_animals[key]['happiness'] = 100
		elif self.current_animals[key]['happiness'] < 0:
			self.current_animals[key]['happiness'] = 0
		if self.current_animals[key]['adoptability'] > 100:
			self.current_animals[key]['adoptability'] = 100
		elif self.current_animals[key]['adoptability'] < 0:
			self.current_animals[key]['adoptability'] = 0
		
		
		if self.scene_path == "res://kennel_room/kennel_room.tscn":
			get_tree().current_scene.setup_kennels()
			
func goto_scene(path):
	
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:
	self.fade = true
	self.prev_scene = self.scene_path
	self.scene_path = path
	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
	# It is now safe to remove the current scene
	current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instantiate()

	# Add it to the active scene, as child of root.
	get_tree().root.add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = current_scene
	
