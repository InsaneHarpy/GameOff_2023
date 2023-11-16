extends Node

var current_scene = null

var active_kennel = -1
var active_animal = {'name': '',
					'type': '',
					'adoptability': 0,
					'health': 0,
					'thirst': 0,
					'hunger': 0,
					'happiness': 0}

var current_animals = {1: {'name': 'Spyro',
						   'type': 'dragon',
						   'adoptability': 75,
						   'health': 25,
						   'thirst': 10,
						   'hunger': 10,
						   'happiness': 0}
						}
var available_animals = {1: "",
						 2: "",
						 3: ""}
var player_energy = 50
var player_money = 500

# amounts for interacting with animals in animal view
var click_feed_petinc : int = 10
var click_feed_stamdec : int = 10

var click_water_petinc : int = 10
var click_water_stamdec : int = 10

var click_play_petinc : int = 10
var click_play_stamdec : int = 10

var animations = {'Dragon':'blue dragon',
				  'Nine Tailed Fox': 'fox'}


# Called when the node enters the scene tree for the first time.
func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func _process(delta):
	if self.player_energy  < 0:
		print("player faint? Advance next day")
		self.player_energy = 0
	if self.player_energy > 100:
		self.player_energy = 100

func goto_scene(path):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:

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
