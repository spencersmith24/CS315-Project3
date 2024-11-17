extends Node3D

const customer = preload("res://Scenes/customer_reg.tscn")

@onready var money_label := $UI/Money

var money_amt = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(5):
		add_child(customer.instantiate())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	money_label.text = str(money_amt)


func _on_shop_btn_pressed() -> void:
	# when scenes change, everything restarts.
	# TODO: figure out how to make it so stuff stays when scenes change OR make it so the scene doesnt have to change. (shop is an overlay or something)
	get_tree().change_scene_to_file("res://Scenes/shop.tscn")
