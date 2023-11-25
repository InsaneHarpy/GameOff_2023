extends Area2D

var update_inc : float = 5.0 # seconds
var time_passed : float = 0.0 # seconds
var time_lastplayedwith : float = 0.0 # seconds

var age : int = 0

@export_group("Pet Stats")
@export var animalName : String = ""
@export var type : String = ""
@export var adoptability : int = 0
@export var health : int = 0
@export var thirst : int = 0
@export var hunger : int = 0
@export var happiness : int = 0

func _ready():
	'''
	Called when the node enters the scene tree for the first time.
	'''
	# probably randomize stats or something here
	# load in files to generate random names5
	var f_names = FileAccess.open("res://animals/pet_names.txt", FileAccess.READ)
	var f_types = FileAccess.open("res://animals/pet_types.txt", FileAccess.READ)
	
	var t_names = f_names.get_as_text()
	var t_types = f_types.get_as_text()
	
	var name_array = t_names.split("\n")
	var type_array = t_types.split("\n")
	
	# when copying over from excel \r character was at the end of every line
	# Use this to sanatize weird characters that may be present in the strings
	for i in range(len(name_array)):
		if "\r" in name_array[i]:
			name_array[i] = name_array[i].replace("\r","")	
			
	for i in range(len(type_array)):
		if "\r" in type_array[i]:
			type_array[i] = type_array[i].replace("\r","")
		if "#" in type_array[i]: # cludgy way to remove unwanted types of animals
			type_array[i] = ""
	
	# remove empty strings from arrays (generally the enter at the end of the file)
	var sanatize = true
	while sanatize:
		var n_idx = name_array.find("")
		var t_idx = type_array.find("")
		if n_idx != -1:
			name_array.remove_at(n_idx)
		if t_idx != -1 :
			type_array.remove_at(t_idx)
		if n_idx == -1 and t_idx == -1:
			sanatize = false
	
	randomize()
	self.animalName = name_array[randi()%len(name_array)]
	self.type = type_array[randi()%len(type_array)]
	self.adoptability = randi()%100 + 1
	self.health = randi()%100 + 1
	self.thirst = randi()%100 + 1
	self.hunger = randi()%100 + 1
	self.happiness = randi()%100 + 1
	
	##### debugging #####
#	self.adoptability = 50
#	self.health = 100
#	self.thirst = 100
#	self.hunger = 100
#	self.happiness = 100
	#####################
	
	print("Initializing new animal:")
	print(str(self.animalName) + " the " + str(self.type))
	print("Adoptability: " + str(self.adoptability))
	print("Health: " + str(self.health))
	print("Thirst: " + str(self.thirst))
	print("Hunger: " + str(self.hunger))
	print("Happiness: " + str(self.happiness))
	
func update_pet_values():
	'''
	Update stats for pet and send signal that pet stats have updated
	'''
	randomize()
	# decrease thirst and hunger by random value between 0 and 10
	self.thirst -= randi()%10+1
	self.hunger -= randi()%10+1

	# put how health decreases based upon health and thirst values
	if self.thirst <= 0: # thirst very bad to be zero.
		self.health -= 10
	elif self.hunger <= 0: # hunger very bad to be zero
		self.health -=10
	elif self.thirst < 75 or self.hunger < 50: # natrual declination of thirst and hunger
		self.health -= randi()%10 +1
	elif self.thirst >=75 and self.hunger >= 50: # increase health because good thirst and hunger
		self.health += randi()%10 + 1
	
	# bad health conditions
	if self.health <= 0:
		self.hunger -= 25
		self.thirst -= 25
		self.happiness -= 50
		self.adoptability = 0
	
	# all values good, increase happiness
	if self.health >75 and self.thirst >=75 and self.hunger >= 50:
		self.happiness += randi()%10 + 1
	if self.time_lastplayedwith > 30:
		self.happiness -= randi()%10 + 1
		
	# how does pet adoptability increase?
	if self.happiness > 75:
		self.adoptability += 1

	# make sure stats are within acceptable bounds
	if self.thirst > 100:
		self.thirst = 100
	elif self.thirst < 0:
		self.thirst = 0
	if self.hunger > 100:
		self.hunger = 100
	elif self.hunger < 0:
		self.hunger = 0
	if self.health > 100:
		self.health = 100
	elif self.health < 0:
		self.health = 0
	if self.happiness > 100:
		self.happiness = 100
	elif self.happiness < 0:
		self.happiness = 0
	if self.adoptability > 100:
		self.adoptability = 100
	elif self.adoptability < 0:
		self.adoptability = 0

func play_with_pet():
	self.time_lastplayedwith = 0
	self.happiness += 10

func water_pet():
	self.thirst += 10

func feed_pet():
	self.hunger += 10

func _process(delta):
	'''
	Called every frame. 'delta' is the elapsed time since the previous frame.
	'''
	pass
	# decrease/increase properties here
#	self.time_passed += delta
#	self.time_lastplayedwith += delta
#	if self.time_passed >= self.update_inc:
#		self.time_passed = 0
#		self.update_pet_values()
#		if self.health != 0:
#			self.age += 1	
#		print("Stats updated for " + str(self.animalName) + " the " + str(self.type))
#		print("Adoptability: " + str(self.adoptability))
#		print("Health: " + str(self.health))
#		print("Thirst: " + str(self.thirst))
#		print("Hunger: " + str(self.hunger))
#		print("Happiness: " + str(self.happiness))
#		print("Age: " + str(self.age))
