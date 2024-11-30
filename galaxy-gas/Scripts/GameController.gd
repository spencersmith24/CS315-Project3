extends Node2D

# Global globals
var money_amt

# Local globals
var rng = RandomNumberGenerator.new()

var customers = ["res://Scenes/Game Objects/Characters/customer_lumberjack.tscn","res://Scenes/Game Objects/Characters/customer_oldguy.tscn","res://Scenes/Game Objects/Characters/customer_pinkgirl.tscn"]

@export var max_customers: int = 8
@export var inn_capacity = 4
@export var stay_chance: float = 2.5
@export var staying_time_multiplier: float = 2

@onready var MONEY_LABEL := $Camera2D/UI/Money
@onready var GAME_SHOP := $Camera2D/UI/Shop

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	money_amt = Globals.money_amt
	MONEY_LABEL.text = str(money_amt)
	
	if not are_tables_full() and not are_tables_upgrading():
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
	if Globals.customers_staying.size() < inn_capacity:
		var random_value = randf() * 100
		if random_value < stay_chance:
			Globals.customers_staying.append(new_customer)
			new_customer.staying = true
			pass
	else:
		Globals.customers_in_store.append(new_customer)
	new_customer.global_position = Vector2(0, 500)
	$Customers.add_child(new_customer)


func _on_change_floors_pressed() -> void:
	if $Camera2D.position.y == -1250:
		$AnimationPlayer.play("move_downstairs")
	else:
		$AnimationPlayer.play("move_upstairs")
		
func are_tables_full():
	for table in $Tables.get_children():
		if not table.is_full():
			return false
	return true

func are_tables_upgrading():
	for table in $Tables.get_children():
		if table.is_upgrading:
			return true
	return false

func _get_customer():
	return customers[randi_range(0, customers.size() - 1)]


func _on_stairs_body_entered(body):
	if body.staying:
		body.find_room()
