extends Node2D

'''
View when clicked on kennel aka close view of pet
Manage pet info from this screen
'''


var kennelNo : int = -1
var empty : bool = false # default true, if false animal is in kennel

# 2d sprite animation variables
@onready var _animated_pet_sprite = get_node("pet sprite")
var _anim_pause = false
var _anim_Pdelta = randi_range(0,1)

# Called when the node enters the scene tree for the first time.
func _ready():
	if not self.empty and Global.active_kennel != -1:
		self.kennelNo = Global.active_kennel
		if Global.active_animal['type'] in Global.animations.keys():
			_animated_pet_sprite.play(Global.animations[Global.active_animal['type']])
		else:
			_animated_pet_sprite.hide()
			print_debug("unknown animal animation")
	else:
		self.empty = true
		_animated_pet_sprite.hide()
		print_debug("Made it to empty animal view/bad global kennel no")
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not self.empty:
		get_node("KennelNo").text = "Kennel Number: " + str(Global.active_kennel)
		self._sprite_animation_pause(delta)
		
		get_node("animalName").text = "Name: " + str(Global.active_animal['name'])
		get_node("animalType").text = "Type: " + str(Global.active_animal['type'])
		get_node("animalAdoptability").text = "Adoptability: " + str(Global.active_animal['adoptability']) + " / 100"
		get_node("animalHealth").text = "Health: " + str(Global.active_animal['health']) + " / 100"
		get_node("animalThirst").text = "Thirst: " + str(Global.active_animal['thirst']) + " / 100"
		get_node("animalHunger").text = "Hunger: " + str(Global.active_animal['hunger']) + " / 100"
		get_node("animalHappiness").text = "Happiness: " + str(Global.active_animal['happiness']) + " / 100"
	else:
		self._animated_pet_sprite.hide()

func _on_feed_pressed():
	if not self.empty and Global.player_energy >= Global.click_feed_stamdec:
		Global.active_animal["hunger"] += Global.click_feed_petinc
		Global.player_energy -= Global.click_feed_stamdec
		if Global.active_animal["hunger"] > 100:
			Global.active_animal["hunger"] = 100


func _on_water_pressed():
	if not self.empty and Global.player_energy >= Global.click_water_stamdec:
		Global.active_animal["thirst"] += Global.click_water_petinc
		Global.player_energy -= Global.click_water_stamdec
		if Global.active_animal["thirst"] > 100:
			Global.active_animal["thirst"] = 100


func _on_play_with_pet_pressed():
	if not self.empty and Global.player_energy >= Global.click_play_stamdec:
		Global.active_animal["happiness"] += Global.click_play_petinc
		Global.player_energy -= Global.click_play_stamdec
		if Global.active_animal["happiness"] > 100:
			Global.active_animal["happiness"] = 100


func _on_back_pressed():
	Global.current_animals[self.kennelNo] = Global.active_animal
	Global.goto_scene("res://kennel_room/kennel_room.tscn")
	# reset global actives otherwise it somehow remembers and will update previous selected animals
	# for some forsaken reason
	# genuinely... why?
	Global.active_animal = {}
	Global.active_kennel = -1
	

func _sprite_animation_pause(delta):
	'''
	Randomly play and pause sprite animation
	'''
	self._anim_Pdelta -= delta
	if self._anim_Pdelta <=0:
		randomize()
		if not self._anim_pause:
			self._anim_pause = true
			_animated_pet_sprite.speed_scale = 0
			_animated_pet_sprite.frame = 0
			self._anim_Pdelta = randf_range(3,30)
		else:
			self._anim_pause = false
			_animated_pet_sprite.speed_scale = 1
			self._anim_Pdelta = 1
