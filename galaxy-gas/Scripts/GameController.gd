extends Node3D

# Global globals
var money_amt

# Local globals
var rng = RandomNumberGenerator.new()
const customer = preload("res://Scenes/customer_reg.tscn")

@export var num_customers : int = 5
@onready var money_label := $UI/Money


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(num_customers):
		$CustomerSpawnTimer.wait_time = rng.randf_range(7.5, 15.0)
		$CustomerSpawnTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	money_amt = Globals.money_amt
	money_label.text = str(money_amt)


func _on_shop_btn_pressed() -> void:
	# when scenes change, everything restarts.
	# TODO: figure out how to make it so stuff stays when scenes change OR make it so the scene doesnt have to change. (shop is an overlay or something)
	get_tree().change_scene_to_file("res://Scenes/shop.tscn")


func _on_customer_spawn_timer_timeout() -> void:
	var new_customer = customer.instantiate()
	add_child(new_customer)
	Globals.customers_in_store.append(new_customer)
	#print(Globals.customers_in_store)
