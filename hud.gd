extends CanvasGroup

var animalMenuClosed : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
#	get_node("Ebar_placeholder/Energy Bar").text = str(Global.player_energy) + " / 100"
	get_node("energy_bar").value = Global.player_energy
	get_node("money/Monies").text = str(Global.player_money)
	
	get_node("PanelContainer/VBoxContainer/Animal1").visible = false
	get_node("PanelContainer/VBoxContainer/Animal2").visible = false
	get_node("PanelContainer/VBoxContainer/Animal3").visible = false
	get_node("PanelContainer/VBoxContainer/available animals").flip_v = false
	
	if Global.scene_path == "res://kennel_room/kennel_room.tscn":
		get_node("Left_ScreenNav").visible = false
		get_node("Right_ScreenNav").visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	get_node("Ebar_placeholder/Energy Bar").text = str(Global.player_energy) + " / 100"
	get_node("energy_bar").value = Global.player_energy
	get_node("money/Monies").text = str(Global.player_money)
	

	if "name" in Global.available_animals[1].keys():
		get_node("PanelContainer/VBoxContainer/Animal1/Animal1 label").text = Global.available_animals[1]["name"]
	else:
		get_node("PanelContainer/VBoxContainer/Animal1/Animal1 label").text = "None"
	if "name" in Global.available_animals[2].keys():
		get_node("PanelContainer/VBoxContainer/Animal2/Animal2 label").text = Global.available_animals[2]["name"]
	else:
		get_node("PanelContainer/VBoxContainer/Animal2/Animal2 label").text = "None"
	if "name" in Global.available_animals[3].keys():
		get_node("PanelContainer/VBoxContainer/Animal3/Animal3 label").text = Global.available_animals[3]["name"]
	else:
		get_node("PanelContainer/VBoxContainer/Animal3/Animal3 label").text = "None"
		
func update_energy(delta):
	Global.player_energy += delta
#	get_node("Ebar_placeholder/Energy Bar").text = str(Global.player_energy) + " / 100"
	get_node("energy_bar").value = Global.player_energy
	
func update_money(delta):
	Global.player_money += delta
	get_node("money/Monies").text = str(Global.player_money)
	
func _on_next_day_pressed():
#	print("Next day pressed")
	Global.player_energy = 100
	if Global.active_kennel != -1:
		Global.current_animals[Global.active_kennel] = Global.active_animal
		Global.active_animal = {}
		Global.active_kennel = -1
	Global.advance_day()
	Global.goto_scene("res://day_advance.tscn")


func _on_available_animals_pressed():
	print(Global.available_animals)
	if self.animalMenuClosed:
		self.open_available_animal_menu()
	else:
		self.close_available_animal_menu()

func open_available_animal_menu():
	get_node("PanelContainer/VBoxContainer/Animal1").visible = true
	get_node("PanelContainer/VBoxContainer/Animal2").visible = true
	get_node("PanelContainer/VBoxContainer/Animal3").visible = true
	get_node("PanelContainer/VBoxContainer/available animals").flip_v = true
	get_node("PanelContainer").position -= Vector2(0,(60-12)*5)
	self.animalMenuClosed = false

func close_available_animal_menu():
	get_node("PanelContainer/VBoxContainer/Animal1").visible = false
	get_node("PanelContainer/VBoxContainer/Animal2").visible = false
	get_node("PanelContainer/VBoxContainer/Animal3").visible = false
	get_node("PanelContainer/VBoxContainer/available animals").flip_v = false
	get_node("PanelContainer").position += Vector2(0,(60-12)*5)
	self.animalMenuClosed = true
	
func _on_animal_1_pressed():
	var availableKennels = []
	for i in range(1,Global.maxKennels+1):
		if i not in Global.fullKennels:
			availableKennels.append(i)
	var minKennel = availableKennels.min()
	
	if minKennel != null and "name" in Global.available_animals[1].keys():
		Global.current_animals[minKennel] = Global.available_animals[1]
		Global.available_animals[1] = {}
		Global.fullKennels.append(minKennel)
		Global.emit_signal("newAnimal")
		Global.fullKennels.sort()
	else:
		print_debug("unable to add animal")
			

func _on_animal_2_pressed():
	var availableKennels = []
	for i in range(1,Global.maxKennels+1):
		if i not in Global.fullKennels:
			availableKennels.append(i)
	var minKennel = availableKennels.min()
	
	if minKennel != null and "name" in Global.available_animals[2].keys():
		Global.current_animals[minKennel] = Global.available_animals[2]
		Global.available_animals[2] = {}
		Global.fullKennels.append(minKennel)
		Global.emit_signal("newAnimal")
		Global.fullKennels.sort()
	else:
		print_debug("unable to add animal")
	
func _on_animal_3_pressed():
	var availableKennels = []
	for i in range(1,Global.maxKennels+1):
		if i not in Global.fullKennels:
			availableKennels.append(i)
	var minKennel = availableKennels.min()
	
	if minKennel != null and "name" in Global.available_animals[3].keys():
		Global.current_animals[minKennel] = Global.available_animals[3]
		Global.available_animals[3] = {}
		Global.fullKennels.append(minKennel)
		Global.emit_signal("newAnimal")
		Global.fullKennels.sort()
	else:
		print_debug("unable to add animal")

func _on_left_screen_nav_pressed():
#	print(Global.fullKennels[0])
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
	var idx = Global.fullKennels.find(Global.active_kennel, 0)
	idx += 1
	if idx == -1:
		idx = len(Global.fullKennels) - 1
	if idx == len(Global.fullKennels):
		idx = 0
	Global.active_kennel = Global.fullKennels[idx]
	Global.active_animal = Global.current_animals[Global.active_kennel]
	Global.emit_signal("scrollAnimal")
