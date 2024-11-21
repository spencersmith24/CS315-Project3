extends RigidBody3D

var rng = RandomNumberGenerator.new()

# Global globals
var customers_in_store
var money_amt

# Local globals
var time_in_store = rng.randf_range(10.0, 25.0)
var money_multiplier = rng.randf_range(1.0, 1.5)

func _process(delta: float) -> void:
	money_amt = Globals.money_amt
	customers_in_store = Globals.customers_in_store

func _ready() -> void:
	$Timer.wait_time = time_in_store
	$Timer.start()

# get money from customer
func _on_timer_timeout() -> void:
	# set global money amount
	Globals.money_amt += calc_money()
	
	Globals.customers_in_store.erase(self)
	queue_free()
	print("Time in store: " + str(time_in_store) + "\nmoney_amt: " + str(money_amt) + "\nGlobal Money_amt: " + str(Globals.money_amt) + "\n")

# calcs money (calc is short for calculates)
func calc_money() -> int:
	return int(time_in_store * money_multiplier + 0.5)
