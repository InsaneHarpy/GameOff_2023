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

# Called when the node enters the scene tree for the first time.
func _ready():
	var kennel_room = preload("res://kennel_room/kennel_room.tscn").instantiate()
	add_child(kennel_room)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
