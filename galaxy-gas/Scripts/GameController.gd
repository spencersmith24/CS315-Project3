extends Node2D

# Global globals
var money_amt

# Local globals
var rng = RandomNumberGenerator.new()
const customer = preload("res://Scenes/2D Scenes/customer_reg_2d.tscn")

@export var num_customers : int = 5

@onready var MONEY_LABEL := $Camera2D/UI/Money
@onready var GAME_SHOP := $Shop

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(num_customers):
		$CustomerSpawnTimer.wait_time = rng.randf_range(7.5, 15.0)
		$CustomerSpawnTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	money_amt = Globals.money_amt
	MONEY_LABEL.text = str(money_amt)


func _on_shop_btn_pressed() -> void:
	GAME_SHOP.toggle_shop()

func _on_customer_spawn_timer_timeout() -> void:
	var new_customer = customer.instantiate()
	add_child(new_customer)
	Globals.customers_in_store.append(new_customer)
