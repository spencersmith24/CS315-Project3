extends RigidBody3D

var rng = RandomNumberGenerator.new()

# Global globals
var customers_in_store
var money_amt

# Local globals
var time_in_store = getTimeInStore()
var money_multiplier = rng.randf_range(1.0, 1.5)

func _process(delta: float) -> void:
	# assign globals
	customers_in_store = Globals.customers_in_store
	money_amt = Globals.money_amt

func _ready() -> void:
	$Timer.wait_time = time_in_store
	$Timer.start()

# get money from customer
func _on_timer_timeout() -> void:
	money_amt += calc_money()
	customers_in_store.erase(self)
	queue_free()

# gets time spent in store, uses this time to calculate money spent
func getTimeInStore() -> int:
	return rng.randf_range(10.0, 25.0)

# guess
func calc_money() -> int:
	return int(time_in_store * money_multiplier + 0.5)
