extends Area2D

var selected = false
var animal = null

@onready var _animated_pet_sprite = get_node("pet sprite")

@export_group("Pet Info")
@export var KennelNo : int = 0
@export var animalName : String = ""
@export  var type : String = ""
@export var adoptability : int = 0
@export var health : int = 0
@export  var thirst : int = 0
@export var hunger : int = 0
@export var happiness : int = 0
@export var toy : String = ""
@export var empty : bool = true

var _anim_pause = false
var _anim_Pdelta = randi_range(0,1)

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
	
func _ready():
	if not self.empty:
		print_debug("start timer")
		$"pet sprite/Timer".start(1)
		if self.type in Global.animations.keys():
			_animated_pet_sprite.play(Global.animations[self.type])
		else:
			_animated_pet_sprite.hide()
			print_debug("unknown animal animation")
	else:
		_animated_pet_sprite.hide()
	
func update_animal(dict={}, kempty = false):
	'''
	Pass dictionary of animal info to kennel
	'''
	self.empty = kempty

	if not self.empty:
		$"pet sprite/Timer".start(1)
		self.animalName = dict['name']
		self.type = dict['type']
		self.adoptability = dict['adoptability']
		self.health = dict['health']
		self.thirst = dict['thirst']
		self.hunger = dict['hunger']
		self.happiness = dict['happiness']
		self.toy = dict['toy']
		
		if self.type in Global.animations.keys():
			_animated_pet_sprite.play(Global.animations[self.type])
			_animated_pet_sprite.show()
		else:
			_animated_pet_sprite.hide()
	else:
		_animated_pet_sprite.hide()
	
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

func _on_timer_timeout():
	randomize()
	if not self._anim_pause:
		self._anim_pause = true
		$"pet sprite/Timer".start(randf_range(3,30))
	else:
		self._anim_pause = false
		_animated_pet_sprite.play(Global.animations[self.type])
		$"pet sprite/Timer".start(1)


func _on_pet_sprite_animation_finished():
	if not self._anim_pause:
		_animated_pet_sprite.play(Global.animations[self.type])
