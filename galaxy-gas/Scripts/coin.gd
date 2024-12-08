extends Node2D

@export var worth: int
@export var label: Resource

var amount_label

func make_label(amount):
	amount_label = label.instantiate()
	amount_label.position = self.global_position
	amount_label.get_node("Label").text = "$" + str(amount)

func _on_mouse_entered() -> void:
	
	Globals.money_amt += worth
	
	get_parent().show_label(amount_label)
	
	queue_free()
	
	pass
