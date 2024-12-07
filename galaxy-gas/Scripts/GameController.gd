extends Node2D

# Global globals
var money_amt

# Local globals
var rng = RandomNumberGenerator.new()

var customers = [
				"res://Scenes/Game Objects/Characters/customer_lumberjack.tscn",
				"res://Scenes/Game Objects/Characters/customer_oldguy.tscn",
				"res://Scenes/Game Objects/Characters/customer_pinkgirl.tscn",
				"res://Scenes/Game Objects/Characters/customer_boy.tscn",
				"res://Scenes/Game Objects/Characters/customer_lesspinkgirl.tscn",
				"res://Scenes/Game Objects/Characters/customer_olderguy.tscn",
				"res://Scenes/Game Objects/Characters/customer_skeleton.tscn",
				"res://Scenes/Game Objects/Characters/customer_viking.tscn",
				"res://Scenes/Game Objects/Characters/customer_woman.tscn"
				]

@onready var MONEY_LABEL := $Camera2D/UI/Money
@onready var GAME_SHOP := $Camera2D/UI/Shop

# Upgrades
@export var max_customers: int = 2
@export var inn_capacity = 4
@export var stay_chance: float = 2.5
@export var inn_time_multiplier: float = 2

@export var marketing_level = 0
@export var max_marketing_level = 20
@export var spawn_rate_multiplier: float = 0.9
@onready var spawn_rate = $CustomerSpawnTimer.wait_time

@export var ambience_level = 0
@export var max_ambience_level = 5
@export var stay_time_multiplier: float = 1.25
var stay_time = rng.randf_range(10.0, 25.0)

var next_customer_needs_to_stay = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Tables/Table1.is_bought = true
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	money_amt = Globals.money_amt
	MONEY_LABEL.text = "$" + str(money_amt)
	
	$CustomerSpawnTimer.wait_time = spawn_rate
	
	if has_available_table():
		next_customer_needs_to_stay = false
		if $CustomerSpawnTimer.is_stopped():
			$CustomerSpawnTimer.start()
	else:
		if has_available_room():
			next_customer_needs_to_stay = true
			if $CustomerSpawnTimer.is_stopped():
				$CustomerSpawnTimer.start()
		
# toggle shop
func _on_shop_btn_pressed() -> void:
	GAME_SHOP.toggle_shop()

# create new customer and add them to the list
func _on_customer_spawn_timer_timeout() -> void:
	spawn_new_customer()
	
func spawn_new_customer():
	var new_customer = load(customers[randi_range(0, customers.size() - 1)]).instantiate()
	
	# Check if there's room for a new customer
	var target_list = Globals.customers_staying if Globals.customers_staying.size() < inn_capacity else Globals.customers_in_store
	if target_list == Globals.customers_staying:
		var random_value = randf() * 100
		if random_value < stay_chance or next_customer_needs_to_stay:
			new_customer.staying = true
	
	# Add the new customer to the right list
	target_list.append(new_customer)
	
	new_customer.global_position = Vector2(0, 500)
	new_customer.stay_time = stay_time
	$Customers.add_child(new_customer)
	
	if new_customer.staying:
		new_customer.find_room()


# Change floors
func _on_change_floors_pressed() -> void:
	var animation = "move_downstairs" if $Camera2D.position.y == -1250 else "move_upstairs"
	$AnimationPlayer.play(animation)

func has_available_table():
	for table in $Tables.get_children():
		if table.is_bought and not table.is_full():
			return true
	return false

func has_available_room():
	for room in $Rooms.get_children():
		if room.size > room.num_occupants:
			return true
	return false

func _get_customer():
	return customers[randi_range(0, customers.size() - 1)]


func _on_stairs_body_entered(body):
	if body.staying:
		body.position = body.room.global_position
		body.nav.set_target_position(body.room.position)

func upgrade_marketing():
	marketing_level += 1
	spawn_rate *= spawn_rate_multiplier

func upgrade_ambience():
	ambience_level += 1
	stay_time *= stay_time_multiplier
	check_ambience()

func check_ambience():
	if ambience_level > 0:
		$Decorations/Upgrade1.visible = true
	if ambience_level > 1:
		$Decorations/Upgrade2.visible = true
	if ambience_level > 2:
		$Decorations/Upgrade3.visible = true
	if ambience_level > 3:
		$Decorations/Upgrade4.visible = true
	if ambience_level > 4:
		$Decorations/Upgrade5.visible = true
