extends Node3D

@onready var moneyLabel := $UI/Money

var moneyAmt = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# this is a test to 
	if moneyAmt != 500:
		moneyAmt += 1
		
	moneyLabel.text = str(moneyAmt)


func _on_shop_btn_pressed() -> void:
	# when scenes change, everything restarts.
	# TODO: figure out how to make it so stuff stays when scenes change OR make it so the scene doesnt have to change. (shop is an overlay or something)
	get_tree().change_scene_to_file("res://Scenes/shop.tscn")
