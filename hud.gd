extends CanvasGroup

var animalMenuClosed : bool = true
var animals_keys = []
var cont_view : int = 3

#var normal_tex = $"Food Options/Food_T1".texture_normal
#var selected_tex = $"Food Options/Food_T1".texture_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
#	get_node("Ebar_placeholder/Energy Bar").text = str(Global.player_energy) + " / 100"
	get_node("energy_bar").value = Global.player_energy
	$Monies.text = str(Global.player_money)
	
	$"PanelContainer/Views/3View".visible = false
	$"PanelContainer/Views/2View".visible = false
	$"PanelContainer/Views/1View".visible = false
	$"PanelContainer/Views/available animals".flip_v = false

	if Global.scene_path == "res://kennel_room/kennel_room.tscn":
		get_node("Left_ScreenNav").visible = false
		get_node("Right_ScreenNav").visible = false
		$"Food Options".visible = false
		
	for key in Global.available_animals:
		if Global.available_animals[key] != {}:
			if key not in self.animals_keys:
				self.animals_keys.append(key)
				print_debug(self.animals_keys)
	
	if len(self.animals_keys) == 3:
		self.cont_view = 3
	elif len(self.animals_keys) == 2:
		self.cont_view = 2
	elif len(self.animals_keys) == 1:
		self.cont_view = 1
	elif len(self.animals_keys) == 0:
		self.cont_view = 0
		
	self.update_available_animals()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	get_node("Ebar_placeholder/Energy Bar").text = str(Global.player_energy) + " / 100"
	get_node("energy_bar").value = Global.player_energy
	$Monies.text = str(Global.player_money)
	
	print($Monies.get_size().x)
	$StretchBox.set_size(Vector2($Monies.get_size().x/5+13, 12))
	
	# make sure only one food option can be selected at a time
	# selected_food == 0 is no option selected
	if Global.selected_food == 1:
		$"Food Options/Food_T1".button_pressed = true
		$"Food Options/Food_T2".button_pressed = false
		$"Food Options/Food_T3".button_pressed = false
	elif Global.selected_food == 2:
		$"Food Options/Food_T1".button_pressed = false
		$"Food Options/Food_T2".button_pressed = true
		$"Food Options/Food_T3".button_pressed = false
	elif Global.selected_food == 3:
		$"Food Options/Food_T1".button_pressed = false
		$"Food Options/Food_T2".button_pressed = false
		$"Food Options/Food_T3".button_pressed = true
	elif Global.selected_food == 0:
		$"Food Options/Food_T1".button_pressed = false
		$"Food Options/Food_T2".button_pressed = false
		$"Food Options/Food_T3".button_pressed = false
	
	# update label count values
	$"Food Options/Food_T1/Label".text = str(Global.player_inventory['foodT1'])
	$"Food Options/Food_T2/Label".text = str(Global.player_inventory['foodT2'])
	$"Food Options/Food_T3/Label".text = str(Global.player_inventory['foodT3'])
	
	# If only one animal then disable left right buttons
	if len(Global.fullKennels) == 1:
		$Left_ScreenNav.visible = false
		$Right_ScreenNav.visible = false
	elif Global.scene_path != "res://kennel_room/kennel_room.tscn":
		$Left_ScreenNav.visible = true
		$Right_ScreenNav.visible = true
	
func update_energy(delta):
	Global.player_energy += delta
#	get_node("Ebar_placeholder/Energy Bar").text = str(Global.player_energy) + " / 100"
	get_node("energy_bar").value = Global.player_energy
	
func update_money(delta):
	Global.player_money += delta
	$Monies.text = str(Global.player_money)
	
func _on_next_day_pressed():
#	print("Next day pressed")
	$buttonSound.play()
	await $buttonSound.finished
	Global.player_energy = 100
	if Global.active_kennel != -1:
		Global.current_animals[Global.active_kennel] = Global.active_animal
		Global.active_animal = {}
		Global.active_kennel = -1
	Global.advance_day()
	Global.goto_scene("res://day_advance.tscn")


func _on_available_animals_pressed():
#	print(Global.available_animals)
	$buttonSound.play()
	await $buttonSound.finished
	
	if self.animalMenuClosed:
		self.open_available_animal_menu()
	else:
		self.close_available_animal_menu()

func open_available_animal_menu():
	if self.cont_view == 3:
		$"PanelContainer/Views/3View".visible = true
		$PanelContainer.position -= Vector2(0,(49)*5)
	elif self.cont_view == 2:
		$"PanelContainer/Views/2View".visible = true
		$PanelContainer.position -= Vector2(0,(36)*5)
	elif self.cont_view == 1:
		$"PanelContainer/Views/1View".visible = true
		$PanelContainer.position -= Vector2(0,(22)*5)
	elif self.cont_view == 0:
		$PanelContainer/Views/NoAvailable.visible = true
		$PanelContainer.position -= Vector2(0,(22)*5)
		
	self.update_available_animals()
		
	$"PanelContainer/Views/available animals".flip_v = true
	self.animalMenuClosed = false

func close_available_animal_menu():
	if self.cont_view == 3:
		$"PanelContainer/Views/3View".visible = false
		$PanelContainer.position += Vector2(0,(49)*5)
	elif self.cont_view == 2:
		$"PanelContainer/Views/2View".visible = false
		$PanelContainer.position += Vector2(0,(36)*5)
	elif self.cont_view == 1:
		$"PanelContainer/Views/1View".visible = false
		$PanelContainer.position += Vector2(0,(22)*5)
	elif self.cont_view == 0:
		$PanelContainer/Views/NoAvailable.visible = false
		$PanelContainer.position += Vector2(0,(22)*5)
		
	$"PanelContainer/Views/available animals".flip_v = false

	self.animalMenuClosed = true
	
func update_available_animals():
	if self.cont_view == 3:
		$"PanelContainer/Views/3View/Animal1/Animal1 label".text = Global.available_animals[self.animals_keys[0]]['name']
		$"PanelContainer/Views/3View/Animal2/Animal2 label".text = Global.available_animals[self.animals_keys[1]]['name']
		$"PanelContainer/Views/3View/Animal3/Animal3 label".text = Global.available_animals[self.animals_keys[2]]['name']
	elif self.cont_view == 2:	
		$"PanelContainer/Views/2View/Animal1/Animal1 label".text = Global.available_animals[self.animals_keys[0]]['name']
		$"PanelContainer/Views/2View/Animal2/Animal2 label".text = Global.available_animals[self.animals_keys[1]]['name']
	elif self.cont_view == 1:
		$"PanelContainer/Views/1View/Animal1/Animal1 label".text = Global.available_animals[self.animals_keys[0]]['name']
	
func _on_animal_1_pressed():
	var availableKennels = []
	for i in range(1,Global.maxKennels+1):
		if i not in Global.fullKennels:
			availableKennels.append(i)
	var minKennel = availableKennels.min()
	
	if minKennel != null and "name" in Global.available_animals[self.animals_keys[0]].keys():
		Global.current_animals[minKennel] = Global.available_animals[self.animals_keys[0]]
		Global.available_animals[self.animals_keys[0]] = {}
		self.animals_keys.remove_at(0)
		Global.fullKennels.append(minKennel)
		Global.emit_signal("newAnimal")
		Global.fullKennels.sort()
		$kennelClosedSound.play()
	else:
		print_debug("unable to add animal")
	
	self.close_available_animal_menu()
	self.cont_view -= 1
	self.update_available_animals()
			

func _on_animal_2_pressed():
	var availableKennels = []
	for i in range(1,Global.maxKennels+1):
		if i not in Global.fullKennels:
			availableKennels.append(i)
	var minKennel = availableKennels.min()
	
	if minKennel != null and "name" in Global.available_animals[self.animals_keys[1]].keys():
		Global.current_animals[minKennel] = Global.available_animals[self.animals_keys[1]]
		Global.available_animals[self.animals_keys[1]] = {}
		self.animals_keys.remove_at(1)
		Global.fullKennels.append(minKennel)
		Global.emit_signal("newAnimal")
		Global.fullKennels.sort()
		$kennelClosedSound.play()
	else:
		print_debug("unable to add animal")
	
	self.close_available_animal_menu()
	self.cont_view -= 1
	self.update_available_animals()
	
func _on_animal_3_pressed():
	var availableKennels = []
	for i in range(1,Global.maxKennels+1):
		if i not in Global.fullKennels:
			availableKennels.append(i)
	var minKennel = availableKennels.min()
	
	if minKennel != null and "name" in Global.available_animals[self.animals_keys[2]].keys():
		Global.current_animals[minKennel] = Global.available_animals[self.animals_keys[2]]
		Global.available_animals[self.animals_keys[2]] = {}
		self.animals_keys.remove_at(2)
		Global.fullKennels.append(minKennel)
		Global.emit_signal("newAnimal")
		Global.fullKennels.sort()
		$kennelClosedSound.play()
	else:
		print_debug("unable to add animal")
	
	self.close_available_animal_menu()
	self.cont_view -= 1
	self.update_available_animals()

func _on_left_screen_nav_pressed():
#	print(Global.fullKennels[0])
	$buttonSound.play()
	await $buttonSound.finished
	Global.current_animals[Global.active_kennel] = Global.active_animal
	var idx = Global.fullKennels.find(Global.active_kennel, 0)
	idx -= 1
	if idx == -1:
		idx = len(Global.fullKennels) - 1
	if idx == len(Global.fullKennels):
		idx = 0
	Global.active_kennel = Global.fullKennels[idx]
	Global.active_animal = Global.current_animals[Global.active_kennel]
	Global.emit_signal("scrollAnimal")

func _on_right_screen_nav_pressed():
#	print(Global.fullKennels[0])
	$buttonSound.play()
	await $buttonSound.finished
	Global.current_animals[Global.active_kennel] = Global.active_animal
	var idx = Global.fullKennels.find(Global.active_kennel, 0)
	idx += 1
	if idx == -1:
		idx = len(Global.fullKennels) - 1
	if idx == len(Global.fullKennels):
		idx = 0
	Global.active_kennel = Global.fullKennels[idx]
	Global.active_animal = Global.current_animals[Global.active_kennel]
	Global.emit_signal("scrollAnimal")

func _on_shop_pressed():
	$buttonSound.play()
	await $buttonSound.finished
	Global.goto_scene("res://store.tscn")


### Toggling buttons for food selection ###
func _on_food_t1_toggled():
	$buttonSound.play()
	if Global.selected_food != 1:
		Global.selected_food = 1
	else:
		Global.selected_food = 0

func _on_food_t2_toggled():
	$buttonSound.play()
	if Global.selected_food != 2:
		Global.selected_food = 2
	else:
		Global.selected_food = 0

func _on_food_t3_toggled():
	$buttonSound.play()
	if Global.selected_food != 3:
		Global.selected_food = 3
	else:
		Global.selected_food = 0
