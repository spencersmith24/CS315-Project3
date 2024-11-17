extends RigidBody3D

var rng = RandomNumberGenerator.new()

var time_in_store = getTimeInStore()
var money_multiplier = rng.randf_range(1.0, 1.5)

func _process(delta: float) -> void:
	pass

func _ready() -> void:
	$Timer.wait_time = time_in_store
	$Timer.start()

func _on_timer_timeout() -> void:
	get_parent().money_amt += calc_money()
	queue_free()

# gets time spent in store, uses this time to calculate money spent
func getTimeInStore() -> int:
	return rng.randf_range(10.0, 25.0)

func calc_money() -> int:
	return int(time_in_store * money_multiplier + 0.5)
