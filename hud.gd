extends CanvasGroup

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Energy Bar").text = "Energy: " + str(Global.player_energy) + " / 100"
	get_node("Monies").text = "Funds: " + str(Global.player_money) + " / 100"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func update_energy(delta):
	Global.player_energy += delta
	get_node("Energy Bar").text = "Energy: " + str(Global.player_energy) + " / 100"
	
func update_money(delta):
	Global.player_money += delta
	get_node("Monies").text = "Funds: " + str(Global.player_money)
	
	
func _on_next_day_pressed():
	print("Next day pressed")

func _on_available_animals_pressed():
	print("show available animals")
