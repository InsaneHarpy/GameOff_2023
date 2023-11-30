extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	## Fill in item prices based upon global values
	$"VBoxContainer/Food Tier 1/Buy/Price".text = "$"+str(Global.foodT1_price)#+"G"
	$"VBoxContainer/Food Tier 2/Buy/Price".text = "$"+str(Global.foodT2_price)#+"G"
	$"VBoxContainer/Food Tier 3/Buy/Price".text = "$"+str(Global.foodT3_price)#+"G"
	$VBoxContainer/Mouse/Buy/Price.text = "$"+str(Global.mouse_price)#+"G"
	$VBoxContainer/Bone/Buy/Price.text = "$"+str(Global.bone_price)#+"G"
	$VBoxContainer/Yarn/Buy/Price.text = "$"+str(Global.yarn_price)#+"G"
	$VBoxContainer/Barley/Buy/Price.text = "$"+str(Global.barley_price)#+"G"
	
func _process(delta):
	### Keep Player money up to date
	$VBoxContainer/Funds/player_money.text = str(Global.player_money)
	
	# if cant afford disable button
	if Global.player_money < Global.foodT1_price:
		$"VBoxContainer/Food Tier 1/Buy".disabled = true
	else:
		$"VBoxContainer/Food Tier 1/Buy".disabled = false
	if Global.player_money < Global.foodT2_price:
		$"VBoxContainer/Food Tier 2/Buy".disabled = true
	else:
		$"VBoxContainer/Food Tier 2/Buy".disabled = false
	if Global.player_money < Global.foodT3_price:
		$"VBoxContainer/Food Tier 3/Buy".disabled = true
	else:
		$"VBoxContainer/Food Tier 3/Buy".disabled = false
	if Global.player_money < Global.mouse_price:
		$VBoxContainer/Mouse/Buy.disabled = true
	else:
		$VBoxContainer/Mouse/Buy.disabled = false
	if Global.player_money < Global.bone_price:
		$VBoxContainer/Bone/Buy.disabled = true
	else:
		$VBoxContainer/Bone/Buy.disabled = false
	if Global.player_money < Global.yarn_price:
		$VBoxContainer/Yarn/Buy.disabled = true
	else:
		$VBoxContainer/Yarn/Buy.disabled = false
	if Global.player_money < Global.barley_price:
		$VBoxContainer/Barley/Buy.disabled = true
	else:
		$VBoxContainer/Barley/Buy.disabled = false

func _on_back_pressed():
	# Apparently you can't have a function await and then use goto_scene...
	# Await has to be before the function you are awaiting
	$buttonSound.play()
	await $buttonSound.finished
	Global.goto_scene(Global.prev_scene)

func _on_buy_food_T1():
	if Global.player_money >= Global.foodT1_price:
		$buttonSound.play()
		Global.player_money -= Global.foodT1_price
		Global.player_inventory['foodT1'] += 1
		print_debug("T1 Food in inventory: ", Global.player_inventory['foodT1'])
	else:
		print_debug("Not enough money to buy food T1")

func _on_buy_food_T2():
	if Global.player_money >= Global.foodT2_price:
		$buttonSound.play()
		Global.player_money -= Global.foodT2_price
		Global.player_inventory['foodT2'] += 1
		print_debug("T2 Food in inventory: ", Global.player_inventory['foodT2'])
	else:
		print_debug("Not enough money to buy food T2")

func _on_buy_food_T3():
	if Global.player_money >= Global.foodT3_price:
		$buttonSound.play()
		Global.player_money -= Global.foodT3_price
		Global.player_inventory['foodT3'] += 1
		print_debug("T3 Food in inventory: ", Global.player_inventory['foodT3'])
	else:
		print_debug("Not enough money to buy food T3")

func _on_buy_mouse():
	if Global.player_money >= Global.mouse_price:
		$buttonSound.play()
		Global.player_money -= Global.mouse_price
		Global.player_inventory['mouse'] += 1
		print_debug("Number toy mouse in inventory: ", Global.player_inventory['mouse'])
	else:
		print_debug("Not enough money to buy toy mouse")

func _on_buy_bone():
	if Global.player_money >= Global.bone_price:
		$buttonSound.play()
		Global.player_money -= Global.bone_price
		Global.player_inventory['bone'] += 1
		print_debug("Number toy bone in inventory: ", Global.player_inventory['bone'])
	else:
		print_debug("Not enough money to buy toy bone")

func _on_buy_yarn():
	if Global.player_money >= Global.yarn_price:
		$buttonSound.play()
		Global.player_money -= Global.yarn_price
		Global.player_inventory['yarn'] += 1
		print_debug("Number toy yarn in inventory: ", Global.player_inventory['yarn'])
	else:
		print_debug("Not enough money to buy toy yarn")

func _on_buy_barley():
	if Global.player_money >= Global.barley_price:
		$buttonSound.play()
		Global.player_money -= Global.barley_price
		Global.player_inventory['barley'] += 1
		print_debug("Number toy barley in inventory: ", Global.player_inventory['barley'])
	else:
		print_debug("Not enough money to buy toy barley")
