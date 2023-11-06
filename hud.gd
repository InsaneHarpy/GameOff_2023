extends CanvasGroup

@export_group("HUD stats")
@export var energy : int = 50
@export var money : int = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Energy Bar").text = "Energy: " + str(self.energy) + " / 100"
	get_node("Monies").text = "Funds: " + str(self.money) + " / 100"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func update_energy(delta):
	self.energy += delta
	get_node("Energy Bar").text = "Energy: " + str(self.energy) + " / 100"
	
func update_money(delta):
	self.money += delta
	get_node("Monies").text = "Funds: " + str(self.money) + " / 100"
	
	
