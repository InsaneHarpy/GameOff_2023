extends Node2D

@onready var _animated_pet_sprite = $"PetRunAway/pet sprite"

var animPart : int = 0
var petrunaway : bool = false
var kennels_petrunaway = []
var pra_idx : int = 0

var petrunaway_timeout : int = 5
var daycount_timeout : int = 2
var between_timeout : float = 0.5

var sound_play : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$DayCounter.visible = false
	$PetRunAway.visible = false
	for key in Global.current_animals:
		if Global.current_animals[key]["happiness"] <= 0:
			self.kennels_petrunaway.append(key)
	
	if len(self.kennels_petrunaway) == 0:
		$DayCounter.visible = true
		$DayCounter/Counter.text = str(Global.daycount)
		$Timer.start(self.daycount_timeout)
		
		$typewriter.play()
		self.sound_play = true
	
	else:
		self.petrunaway = true
		var petname = Global.current_animals[self.kennels_petrunaway[self.pra_idx]]['name']
		var animation = Global.animations[Global.current_animals[self.kennels_petrunaway[self.pra_idx]]['type']]
		$PetRunAway/runaway_text.text = petname +  " was unhappy and ran away!"
		_animated_pet_sprite.play(animation)
		$PetRunAway.visible = true
		
		Global.player_money -= Global.pet_runaway_penalty
		Global.fullKennels.erase(self.kennels_petrunaway[self.pra_idx])
		Global.current_animals.erase(self.kennels_petrunaway[self.pra_idx])
		
		self.pra_idx += 1

		$Timer.start(self.petrunaway_timeout)
			
			
func _on_timer_timeout():
	get_node("Timer").stop()
	if self.petrunaway:
		if animPart ==0:
			$PetRunAway.visible = false
			$Timer.start(self.between_timeout)
			if len(self.kennels_petrunaway) == self.pra_idx:
				self.petrunaway = false
			else:
				animPart += 1
		else:
			var petname = Global.current_animals[self.kennels_petrunaway[self.pra_idx]]['name']
			var animation = Global.animations[Global.current_animals[self.kennels_petrunaway[self.pra_idx]]['type']]
			$PetRunAway/runaway_text.text = petname +  " was unhappy and ran away!"
			_animated_pet_sprite.play(animation)
			$PetRunAway.visible = true
			$Timer.start(self.petrunaway_timeout)
			
			Global.player_money -= Global.pet_runaway_penalty
			Global.fullKennels.erase(self.kennels_petrunaway[self.pra_idx])
			Global.current_animals.erase(self.kennels_petrunaway[self.pra_idx])
			
			self.pra_idx += 1
			animPart -= 1
	else:
		if not self.sound_play:
			$typewriter.play()
			self.sound_play = true
		$Timer.start(self.daycount_timeout)
		if animPart == 0:
			$DayCounter.visible = true
			$DayCounter/Counter.text = str(Global.daycount)
			animPart += 1
		elif animPart == 1:
			$DayCounter/Counter.text = ""
			animPart += 1
		elif animPart == 2:
			Global.daycount += 1
			$DayCounter/Counter.text = str(Global.daycount)
			animPart += 1
		else:
			Global.goto_scene("res://kennel_room/kennel_room.tscn")
