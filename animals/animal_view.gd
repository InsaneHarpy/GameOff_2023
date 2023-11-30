extends Node2D

'''
View when clicked on kennel aka close view of pet
Manage pet info from this screen
'''


var kennelNo : int = -1
var empty : bool = false # default true, if false animal is in kennel

# 2d sprite animation variables
@onready var _animated_pet_sprite = get_node("pet sprite")
@onready var _animated_toy_sprite = get_node("Toy")
var _anim_pause = false
var _anim_Pdelta = randi_range(0,1)

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("scrollAnimal", _ready) # This is hacky
	$kennelOpenSound.play()
	$ToyView.visible = false
	$ManagePet.visible = true
	$PetInfo.visible = true
	
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
		$PetInfo/KennelNo.text = "Kennel Number: " + str(Global.active_kennel)
		self._sprite_animation_pause(delta)
		
		# pet info
		$PetInfo/HBoxContainer/VBoxContainer/animalName.text = "Name: " + str(Global.active_animal['name'])
		$PetInfo/HBoxContainer/VBoxContainer/animalType.text = "Type: " + str(Global.active_animal['type'])
		$PetInfo/HBoxContainer/VBoxContainer/animalAdoptability.text = "Adoptability: " + str(Global.active_animal['adoptability']) + " / 100"
		$PetInfo/HBoxContainer/VBoxContainer/animalHealth.text = "Health: " + str(Global.active_animal['health']) + " / 100"
		$PetInfo/HBoxContainer/VBoxContainer/animalThirst.text = "Thirst: " + str(Global.active_animal['thirst']) + " / 100"
		$PetInfo/HBoxContainer/VBoxContainer/animalHunger.text = "Hunger: " + str(Global.active_animal['hunger']) + " / 100"
		$PetInfo/HBoxContainer/VBoxContainer/animalHappiness.text = "Happiness: " + str(Global.active_animal['happiness']) + " / 100"
	
		# handle if there is a toy assigned to pet
		if Global.active_animal['toy'] == 'mouse':
			$Toy.visible = true
			self._animated_toy_sprite.play('mouse')
		elif Global.active_animal['toy'] == 'bone':
			$Toy.visible = true
			self._animated_toy_sprite.play('bone')
		elif Global.active_animal['toy'] == 'yarn':
			$Toy.visible = true
			self._animated_toy_sprite.play('yarn')
		elif Global.active_animal['toy'] == 'barley':
			$Toy.visible = true
			self._animated_toy_sprite.play('barley')
		else:
			$Toy.visible = false
			
	else:
		self._animated_pet_sprite.hide()
		
	# owned toys
	$ToyView/Mouse/Count.text = "Owned: "+ str(Global.player_inventory['mouse'])
	$ToyView/Bone/Count.text = "Owned: "+ str(Global.player_inventory['bone'])
	$ToyView/Yarn/Count.text = "Owned: "+ str(Global.player_inventory['yarn'])
	$ToyView/Barley/Count.text = "Owned: "+ str(Global.player_inventory['barley'])
	
	# disable toy buttons if don't own toy:
	if Global.player_inventory['mouse'] <= 0 or Global.active_animal['toy'] == 'mouse':
		$ToyView/Mouse/Give.disabled = true
	else:
		$ToyView/Mouse/Give.disabled = false
		
	if Global.player_inventory['bone'] <= 0 or Global.active_animal['toy'] == 'bone':
		$ToyView/Bone/Give.disabled = true
	else:
		$ToyView/Bone/Give.disabled = false
		
	if Global.player_inventory['yarn'] <= 0 or Global.active_animal['toy'] == 'yarn':
		$ToyView/Yarn/Give.disabled = true
	else:
		$ToyView/Yarn/Give.disabled = false
		
	if Global.player_inventory['barley'] <= 0 or Global.active_animal['toy'] == 'barley':
		$ToyView/Barley/Give.disabled = true
	else:
		$ToyView/Barley/Give.disabled = false
		
	# Disable buttons if player energy is too low
		
	if Global.player_energy < Global.click_feed_stamdec:
		$ManagePet/HBoxContainer/Feed.disabled = true
	else:
		if Global.selected_food == 0:
			$ManagePet/HBoxContainer/Feed.disabled = true
		elif Global.selected_food == 1 and Global.player_inventory['foodT1'] <= 0:
			$ManagePet/HBoxContainer/Feed.disabled = true
		elif Global.selected_food == 2 and Global.player_inventory['foodT2'] <= 0:
			$ManagePet/HBoxContainer/Feed.disabled = true
		elif Global.selected_food == 3 and Global.player_inventory['foodT3'] <= 0:
			$ManagePet/HBoxContainer/Feed.disabled = true
		else:
			$ManagePet/HBoxContainer/Feed.disabled = false
	
	if Global.player_energy < Global.click_water_stamdec:
		$ManagePet/HBoxContainer/Water.disabled = true
	else:
		$ManagePet/HBoxContainer/Water.disabled = false

	if Global.player_energy < Global.click_play_stamdec:
		$"ManagePet/HBoxContainer/Play with pet".disabled = true
	else:
		$"ManagePet/HBoxContainer/Play with pet".disabled = false
	
	# Disable toy buttons if don't own toy
	
	# Limit adoptability of pet if ranking is too low
	
	if Global.active_animal['adoptability'] < 70:
		$ManagePet/Adopt.disabled = true
	else:
		$ManagePet/Adopt.disabled = false
		
func _on_feed_pressed():
	if not self.empty and Global.player_energy >= Global.click_feed_stamdec:
		$buttonSound.play()
		if Global.selected_food == 1:
			Global.player_inventory['foodT1'] -= 1
			Global.active_animal["hunger"] += Global.click_feed_petinc['foodT1']
		elif Global.selected_food == 2:
			Global.player_inventory['foodT2'] -= 1
			Global.active_animal["hunger"] += Global.click_feed_petinc['foodT2']
		elif Global.selected_food == 3:
			Global.player_inventory['foodT3'] -= 1
			Global.active_animal["hunger"] += Global.click_feed_petinc['foodT3']
		Global.player_energy -= Global.click_feed_stamdec
		if Global.active_animal["hunger"] > 100:
			Global.active_animal["hunger"] = 100

func _on_water_pressed():
	if not self.empty and Global.player_energy >= Global.click_water_stamdec:
		$buttonSound.play()
		Global.active_animal["thirst"] += Global.click_water_petinc
		Global.player_energy -= Global.click_water_stamdec
		if Global.active_animal["thirst"] > 100:
			Global.active_animal["thirst"] = 100

func _on_play_with_pet_pressed():
	if not self.empty and Global.player_energy >= Global.click_play_stamdec:
		$buttonSound.play()
		Global.active_animal["happiness"] += Global.click_play_petinc
		Global.player_energy -= Global.click_play_stamdec
		if Global.active_animal["happiness"] > 100:
			Global.active_animal["happiness"] = 100

func _on_back_pressed():
	Global.current_animals[self.kennelNo] = Global.active_animal
	$buttonSound.play()
	await $buttonSound.finished
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

func _on_adpot_pressed():
	$buttonSound.play()
	await $buttonSound.finished
	var addMon = Global.active_animal["adoptability"]
	Global.player_money += addMon
	Global.current_animals.erase(Global.active_kennel)
	Global.fullKennels.erase(Global.active_kennel)
	Global.active_kennel = -1
	Global.active_animal = {}
	Global.goto_scene("res://kennel_room/kennel_room.tscn")

## Toggle between clipboard pages
func _on_toys_pressed():
	$buttonSound.play()
	$PetInfo.visible = false
	$ManagePet.visible = false
	$ToyView.visible = true
func _on_toy_view_back_pressed():
	$buttonSound.play()
	$ToyView.visible = false
	$PetInfo.visible = true
	$ManagePet.visible = true


func _on_give_mouse_pressed():
	$buttonSound.play()
	if Global.active_animal['toy']  == "":
		Global.active_animal['toy'] = 'mouse'
		Global.player_inventory['mouse'] -= 1
	else:
		Global.player_inventory[Global.active_animal['toy']] += 1
		Global.active_animal['toy'] = 'mouse'
		Global.player_inventory['mouse'] -= 1
		
func _on_give_bone_pressed():
	$buttonSound.play()
	if Global.active_animal['toy']  == "":
		Global.active_animal['toy'] = 'bone'
		Global.player_inventory['bone'] -= 1
	else:
		Global.player_inventory[Global.active_animal['toy']] += 1
		Global.active_animal['toy'] = 'bone'
		Global.player_inventory['bone'] -= 1


func _on_give_yarn_pressed():
	$buttonSound.play()
	if Global.active_animal['toy']  == "":
		Global.active_animal['toy'] = 'yarn'
		Global.player_inventory['yarn'] -= 1
	else:
		Global.player_inventory[Global.active_animal['toy']] += 1
		Global.active_animal['toy'] = 'yarn'
		Global.player_inventory['yarn'] -= 1

func _on_give_barley_pressed():
	$buttonSound.play()
	if Global.active_animal['toy']  == "":
		Global.active_animal['toy'] = 'barley'
		Global.player_inventory['barley'] -= 1
	else:
		Global.player_inventory[Global.active_animal['toy']] += 1
		Global.active_animal['toy'] = 'barley'
		Global.player_inventory['barley'] -= 1
