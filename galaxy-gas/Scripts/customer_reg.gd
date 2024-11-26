extends CharacterBody2D

var rng = RandomNumberGenerator.new()

# Global globals
var customers_in_store
var money_amt

var staying = false

# Local globals
var time_in_store = rng.randf_range(10.0, 25.0)
var money_multiplier = rng.randf_range(1.0, 1.5)
#var chair

@export var accel = 5
@export var speed = 300

@onready var nav: NavigationAgent2D = $NavigationAgent2D

@onready var tables = $"../../Tables".get_children()

var chair

func _process(delta: float) -> void:
	money_amt = Globals.money_amt
	customers_in_store = Globals.customers_in_store

# move characters around to find table to sit at
func _physics_process(delta: float) -> void:
	
	if staying == false:
		var direction = Vector3()
		nav.target_position = chair.global_position
	
		direction = (nav.get_next_path_position() - global_position).normalized()
		velocity = velocity.lerp(direction * speed, accel * delta)
	else:
		var direction = Vector3()
		nav.target_position = Vector2(1800, 800)
		
		direction = (nav.get_next_path_position() - global_position).normalized()
		velocity = velocity.lerp(direction * speed, accel * delta)
	
	move_and_slide()

func _ready() -> void:
	if staying == true:
		time_in_store *= get_parent().get_parent().staying_time_multiplier
	else:
		find_chair()
	$InStoreTimer.wait_time = time_in_store
	$InStoreTimer.start()
	
# get money from customer, erase from customer list, queue free
func _on_timer_timeout() -> void:
	# set global money amount
	Globals.money_amt += calc_money()
	if staying:
		Globals.customers_staying.erase(self)
	else:
		chair.is_taken = false
		chair.customer_at_chair = null
		Globals.customers_in_store.erase(self)
		
	queue_free()

# calcs money (calc is short for calculates, it's slang)
func calc_money() -> int:
	return int(time_in_store * money_multiplier + 0.5)

func find_chair():
	var rand_table
	while not chair:
		rand_table = tables[rng.randi_range(0, tables.size() - 1)]
		# UN-UPGRADED TABLED
		if not rand_table.is_upgraded:
			if not rand_table.is_full():
				for table_chair in rand_table.small_chairs:
					if table_chair.is_taken == false:
						chair = table_chair
						chair.is_taken = true
						chair.customer_at_chair = self
						break
			else:
				continue
		# UPGRADED TABLES
		else:
			if not rand_table.is_full():
				print ("table not full")
				for table_chair in rand_table.big_chairs:
					if table_chair.is_taken == false:
						chair = table_chair
						chair.is_taken = true
						chair.customer_at_chair = self
						break
			else:
				continue

				#
		#else:
			#if rng.randi_range(0,1) == 0:
				#chair = rand_table.get_children()[1].get_children()[0].get_children()[rng.randi_range(0,1)]
			#else:
				#chair = rand_table.get_children()[1].get_children()[1].get_children()[rng.randi_range(0,1)]
