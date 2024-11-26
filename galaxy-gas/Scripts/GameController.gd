extends Node2D

# Global globals
var money_amt

# Local globals
var rng = RandomNumberGenerator.new()
const customer = preload("res://Scenes/Scenes/customer_reg_2d.tscn")

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
	
	if Globals.customers_in_store.size() < max_customers:
		if $CustomerSpawnTimer.is_stopped():
			$CustomerSpawnTimer.start()
		
# toggle shop
func _on_shop_btn_pressed() -> void:
	GAME_SHOP.toggle_shop()

# create new customer and add them to the list
func _on_customer_spawn_timer_timeout() -> void:
	spawn_new_customer()
	
func spawn_new_customer():
	var new_customer = customer.instantiate()
	if Globals.customers_staying.size() < inn_capacity:
		var random_value = randf() * 100
		if random_value < stay_chance:
			Globals.customers_staying.append(new_customer)
			new_customer.staying = true
			pass
	else:
		Globals.customers_in_store.append(new_customer)
	$Customers.add_child(new_customer)


func _on_change_floors_pressed() -> void:
	if $Camera2D.position.y == -1250:
		$AnimationPlayer.play("move_downstairs")
	else:
		$AnimationPlayer.play("move_upstairs")
