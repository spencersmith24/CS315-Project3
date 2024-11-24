extends Node2D

# Global globals
var money_amt

# Local globals
var rng = RandomNumberGenerator.new()
const customer = preload("res://Scenes/Scenes/customer_reg_2d.tscn")

@export var max_customers: int = 5

@onready var MONEY_LABEL := $Camera2D/UI/Money
@onready var GAME_SHOP := $Shop

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#for i in max_customers:
		#$CustomerSpawnTimer.wait_time = rng.randf_range(1, 2)
		#$CustomerSpawnTimer.start()
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	money_amt = Globals.money_amt
	MONEY_LABEL.text = str(money_amt)

	if Globals.customers_in_store.size() < max_customers:
		if $CustomerSpawnTimer.is_stopped():
			$CustomerSpawnTimer.start()
		
# toggle shop
func _on_shop_btn_pressed() -> void:
	GAME_SHOP.toggle_shop()

# create new customer and add them to the list
func _on_customer_spawn_timer_timeout() -> void:
	print(Globals.customers_in_store.size())
	var new_customer = customer.instantiate()
	Globals.customers_in_store.append(new_customer)
	$Customers.add_child(new_customer)
