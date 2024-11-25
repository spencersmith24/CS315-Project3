extends RigidBody2D

var rng = RandomNumberGenerator.new()

# Global globals
var customers_in_store
var money_amt

var staying = false

# Local globals
var time_in_store = rng.randf_range(10.0, 25.0)
var money_multiplier = rng.randf_range(1.0, 1.5)

func _process(delta: float) -> void:
	money_amt = Globals.money_amt
	customers_in_store = Globals.customers_in_store

func _ready() -> void:
	if staying == true:
		time_in_store *= get_parent().get_parent().staying_time_multiplier
	$InStoreTimer.wait_time = time_in_store
	$InStoreTimer.start()
	
# get money from customer, erase from customer list, queue free
func _on_timer_timeout() -> void:
	# set global money amount
	Globals.money_amt += calc_money()
	if staying:
		Globals.customers_staying.erase(self)
	else:
		Globals.customers_in_store.erase(self)
	queue_free()

# calcs money (calc is short for calculates, it's slang)
func calc_money() -> int:
	return int(time_in_store * money_multiplier + 0.5)
