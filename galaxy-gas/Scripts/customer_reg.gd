extends CharacterBody2D

var rng = RandomNumberGenerator.new()

# Global globals
var customers_in_store
var money_amt

var staying = false

# Local globals
var time_in_store = rng.randf_range(10.0, 25.0)
var money_multiplier = rng.randf_range(1.0, 1.5)

@export var accel = 5
@export var speed = 200

@onready var anim_tree = $AnimationTree
@onready var anim_player = $AnimationPlayer

@onready var nav: NavigationAgent2D = $NavigationAgent2D

@onready var tables = $"../../Tables".get_children()

@onready var rooms = $"../../Rooms".get_children()

@onready var stairs = $"../../Stairs"

var chair
var room

func _process(delta: float) -> void:
	money_amt = Globals.money_amt
	customers_in_store = Globals.customers_in_store

# move characters around to find table to sit at
func _physics_process(delta: float) -> void:
	
	if staying == false:
		var direction = Vector2()
		nav.set_target_position(chair.global_position)
	
		direction = (nav.get_next_path_position() - global_position).normalized()
		velocity = velocity.lerp(direction * speed, accel * delta)
	else:
		var direction = Vector2()
		nav.set_target_position(stairs.global_position)
		
		direction = (nav.get_next_path_position() - global_position).normalized()
		velocity = velocity.lerp(direction * speed, accel * delta)
		
	if(velocity.x > 0):
		$Sprite2D.scale.x = 5
	elif (velocity.x < 0):
		$Sprite2D.scale.x = -5
	if abs(velocity.x) > 0 and abs(velocity.x) > abs(velocity.y):
		anim_tree['parameters/conditions/walk_up'] = false
		anim_tree['parameters/conditions/walk_down'] = false
		anim_tree['parameters/conditions/walk_sideways'] = true
	elif velocity.y > 100 and abs(velocity.y) > abs(velocity.x):
		anim_tree['parameters/conditions/walk_sideways'] = false
		anim_tree['parameters/conditions/walk_up'] = false
		anim_tree['parameters/conditions/walk_down'] = true
	elif velocity.y < -100 and abs(velocity.y) > abs(velocity.x):
		anim_tree['parameters/conditions/walk_sideways'] = false
		anim_tree['parameters/conditions/walk_down'] = false
		anim_tree['parameters/conditions/walk_up'] = true
	
	move_and_slide()

func _ready() -> void:
	if staying == true:
		time_in_store *= get_parent().get_parent().staying_time_multiplier
		nav.set_navigation_layer_value(1, false)
		nav.set_navigation_layer_value(2, true)
	else:
		find_chair()
	$InStoreTimer.wait_time = time_in_store
	$InStoreTimer.start()
	
# get money from customer, erase from customer list, queue free
func _on_timer_timeout() -> void:
	leave()

# customer leaves and pays
func leave():
	# set global money amount
	Globals.money_amt += calc_money()
	if staying:
		Globals.customers_staying.erase(self)
		room.num_occupants -= 1
		room = null
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
				for table_chair in rand_table.big_chairs:
					if table_chair.is_taken == false:
						chair = table_chair
						chair.is_taken = true
						chair.customer_at_chair = self
						break
			else:
				continue

func find_room():
	var rand_room
	while not room:
		rand_room = rooms[rng.randi_range(0, rooms.size() - 1)]
		for bed_room in rooms:
			if not bed_room.is_full():
				bed_room.num_occupants += 1
				room = bed_room
				position = room.global_position
				break
			else:
				continue

func sit_in_chair():
	speed = 0
	velocity = Vector2(0,0)
	position = chair.global_position
	
	# determine sitting position
	if chair.scene_file_path == "res://Scenes/Game Objects/chair_back.tscn":
		reset_anim()
		anim_tree['parameters/conditions/idle_up'] = true
	elif chair.scene_file_path == "res://Scenes/Game Objects/chair_front.tscn":
		reset_anim()
		anim_tree['parameters/conditions/idle_down'] = true
	elif chair.scene_file_path == "res://Scenes/Game Objects/chair_horizontal.tscn":
		reset_anim()
		anim_tree['parameters/conditions/idle_sideways'] = true
		$Sprite2D.scale.x = 5
		if chair.name == "Chair_Horizontal_L":
			$Sprite2D.flip_h = false
		elif chair.name == "Chair_Horizontal_R":
			$Sprite2D.flip_h = true
			

func reset_anim():
		anim_tree['parameters/conditions/walk_up'] = false
		anim_tree['parameters/conditions/walk_down'] = false
		anim_tree['parameters/conditions/walk_sideways'] = false
