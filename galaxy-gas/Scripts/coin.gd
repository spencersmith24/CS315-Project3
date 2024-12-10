extends Node2D

@export var worth: int
@export var label: Resource

@onready var root_node = get_parent().get_parent().get_parent()

var amount_label
var upstairs = false
var multiplier = 1

func make_label(amount):
	amount_label = label.instantiate()
	amount_label.position = self.global_position
	amount_label.get_node("Label").text = "$" + str(amount)

func _on_mouse_entered() -> void:
	pick_up_coin()

# waiter/bellboy picks up money and takes a 25% cut
func _on_body_entered(body: Node2D) -> void:
	if body.scene_file_path == "res://Scenes/Game Objects/Characters/waiter.tscn" or body.scene_file_path == "res://Scenes/Game Objects/Characters/bellboy.tscn":
		multiplier = 0.75
		pick_up_coin()
		body.searching = true

func pick_up_coin():
	root_node.get_node("Camera2D/sfx").get_node("coin_collect").play()
	
	make_label(int(worth * multiplier + 0.5))
	
	# delete coin from list  
	if Globals.upstairs_coins.has(self):
		Globals.upstairs_coins.erase(self)
	else:
		Globals.downstairs_coins.erase(self)
	
	Globals.money_amt += int(worth * multiplier + 0.5)
	get_parent().get_parent().show_label(amount_label)
	
	queue_free()
