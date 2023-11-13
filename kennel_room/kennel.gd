extends Area2D

var selected = false
var animal = null

@export_group("Pet Info")
@export var KennelNo : int = 0
@export var animalName : String = ""
@export var type : String = ""
@export var adoptability : int = 0
@export var health : int = 0
@export  var thirst : int = 0
@export var hunger : int = 0
@export var happiness : int = 0

signal clicked(name)

func _input_event(viewport, event, shape_idx):
	'''
	Handles clicking events that overlap with the collision shape2D
	'''
	if (event is InputEventMouseButton and
	event.button_index == MOUSE_BUTTON_LEFT and
	event.is_pressed()):
		#print("clicked-kennel")
		self.on_click()
		
func on_click():
	if selected:
		selected = false
	else:
		selected = true
	# Emit signal that kennel was clicked
	clicked.emit(self)
	
func _process(delta):
	# set values for kennel info
	get_node("KennelNo").text = "Kennel Number: " + str(self.KennelNo)
	get_node("animalName").text = "Name: " + str(self.animalName)
	get_node("animalType").text = "Type: " + str(self.type)
	get_node("animalAdoptability").text = "Adoptability: " + str(self.adoptability) + " / 100"
	get_node("animalHealth").text = "Health: " + str(self.health) + " / 100"
	get_node("animalThirst").text = "Thirst: " + str(self.thirst) + " / 100"
	get_node("animalHunger").text = "Hunger: " + str(self.hunger) + " / 100"
	get_node("animalHappiness").text = "Happiness: " + str(self.happiness) + " / 100"
	
func _enter_tree():
	'''
	On node creation, if parent has _kennel_clicked method
	connect clicked signal to parent
	'''
	if get_parent().has_method("_kennel_clicked"):
		clicked.connect(get_parent()._kennel_clicked)

func _exit_tree():
	'''
	On node deletion/freeing, if parent has _kennel_clicked method
	disconnect clicked signal to parent (assumed node would already be connected)
	'''
	if get_parent().has_method("_kennel_clicked"):
		clicked.disconnect(get_parent()._kennel_clicked)
