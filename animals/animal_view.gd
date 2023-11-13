extends Node2D

'''
View when clicked on kennel aka close view of pet
Manage pet info from this screen
'''


var kennelNo : int = -1
var isEmpty : bool = false # default true, if false animal is in kennel

# Called when the node enters the scene tree for the first time.
func _ready():
	if not isEmpty:
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not isEmpty:
		get_node("KennelNo").text = "Kennel Number: " + str(self.kennelNo)
		get_node("animalName").text = "Name: " + str(get_node("animal").animalName)
		get_node("animalType").text = "Type: " + str(get_node("animal").type)
		get_node("animalAdoptability").text = "Adoptability: " + str(get_node("animal").adoptability) + " / 100"
		get_node("animalHealth").text = "Health: " + str(get_node("animal").health) + " / 100"
		get_node("animalThirst").text = "Thirst: " + str(get_node("animal").thirst) + " / 100"
		get_node("animalHunger").text = "Hunger: " + str(get_node("animal").hunger) + " / 100"
		get_node("animalHappiness").text = "Happiness: " + str(get_node("animal").happiness) + " / 100"

func _on_feed_pressed():
	if not isEmpty:
		get_node("animal").hunger += 10
		if get_node("animal").hunger > 100:
			get_node("animal").hunger = 100


func _on_water_pressed():
	if not isEmpty:
		get_node("animal").thirst += 10
		if get_node("animal").thirst > 100:
			get_node("animal").thirst = 100


func _on_play_with_pet_pressed():
	if not isEmpty:
		get_node("animal").happiness += 10
		if get_node("animal").happiness > 100:
			get_node("animal").happiness = 100
