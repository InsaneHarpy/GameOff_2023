extends Node2D

var temp_animal = { 'name': '',
					'type': '',
					'kennel': -1,
					'adoptability': 0,
					'health': 0,
					'thirst': 0,
					'hunger': 0,
					'happiness': 0}

var current_animals = []
var available_animals = []
var player_energy = 100
var player_money = 500

# Trying something of instantiating views and adding removing children
# could have a significant memory load, if so delete nodes
@onready var kennel_room = get_node("kennel_room")
var animal_view = preload("res://animals/animal_view.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func transition(current, new):
	print("Transitioning from " + str(current))
	print("to " + str(new))
	remove_child(current)
	add_child(new)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
