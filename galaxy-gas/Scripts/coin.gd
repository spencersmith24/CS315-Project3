extends Node2D

@export var worth: int
@export var label: Resource

@onready var root_node = get_parent().get_parent().get_parent()

var amount_label

func make_label(amount):
	amount_label = label.instantiate()
	amount_label.position = self.global_position
	amount_label.get_node("Label").text = "$" + str(amount)

func _on_mouse_entered() -> void:
	pick_up_coin()

func _on_body_entered(body: Node2D) -> void:
	if body.scene_file_path == "res://Scenes/Game Objects/Characters/waiter.tscn":
		pick_up_coin()

func pick_up_coin():
	# delete coin from waiter's list  
	Globals.coins.erase(self)

	Globals.money_amt += worth	
	get_parent().get_parent().show_label(amount_label)
	
	# send him searching
	root_node.get_node("waiter").searching = true
	queue_free()
