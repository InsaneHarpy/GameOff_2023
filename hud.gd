extends CanvasGroup

# Called when the node enters the scene tree for the first time.
func _ready():
#	get_node("Ebar_placeholder/Energy Bar").text = str(Global.player_energy) + " / 100"
	get_node("energy_bar").value = Global.player_energy
	get_node("money/Monies").text = str(Global.player_money)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	get_node("Ebar_placeholder/Energy Bar").text = str(Global.player_energy) + " / 100"
	get_node("energy_bar").value = Global.player_energy
	get_node("money/Monies").text = str(Global.player_money)
	
func update_energy(delta):
	Global.player_energy += delta
#	get_node("Ebar_placeholder/Energy Bar").text = str(Global.player_energy) + " / 100"
	get_node("energy_bar").value = Global.player_energy
	
func update_money(delta):
	Global.player_money += delta
	get_node("money/Monies").text = str(Global.player_money)
	
	
func _on_next_day_pressed():
	print("Next day pressed")
	Global.player_energy = 100

func _on_available_animals_pressed():
	print("show available animals")
