extends Control

@onready var tables = $"../../../Tables".get_children()
@onready var rooms = $"../../../Rooms".get_children()
@onready var root_node = $"../../.."

# Upgrade variables

@export var table_upgrade_cost = 1000
@export var new_table_cost = 100
@export var table_upgrade_cost_multiplier = 1.4
@export var new_table_cost_multiplier = 2

@export var inn_capacity_upgrade_cost = 500
@export var inn_capacity_upgrade_cost_multiplier = 2.0

@export var marketing_upgrade_cost = 50
@export var marketing_upgrade_cost_multiplier = 1.5

@export var ambience_upgrade_cost = 100
@export var ambience_upgrade_cost_multiplier = 3

var has_all_tables = false
var tables_bought = 1

var tables_upgraded = 0
var rooms_upgraded = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	process_mode = PROCESS_MODE_DISABLED
	
	# tables/chairs
	$"Upgrades/TablesButton/TablesButton/Price".text = "$" + str(new_table_cost)
	$Stats/Chairs.text = "Chairs: " + str(root_node.max_customers)
	
	# inn
	$"Upgrades/RoomsButton/RoomsButton/Price".text = "$" + str(inn_capacity_upgrade_cost)
	$Stats/InnSpace.text = "Inn Space: " + str(root_node.inn_capacity)

	# marketing
	$Upgrades/MarketingButton/MarketingButton/Price.text = "$" + str(marketing_upgrade_cost)
	$Stats/Marketing.text = "Marketing: " + str(root_node.marketing_level)
	
	# ambience
	$Upgrades/AmbienceButton/AmbienceButton/Price.text = "$" + str(ambience_upgrade_cost)
	$Stats/Ambience.text = "Ambience: " + str(root_node.ambience_level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if root_node.ambience_level >= root_node.max_ambience_level:
		$Upgrades/AmbienceButton/AmbienceButton.disabled = true
	
	if root_node.marketing_level >= root_node.max_marketing_level:
		$Upgrades/MarketingButton/MarketingButton.disabled = true

func _on_exit_shop_btn_pressed() -> void:
	toggle_shop()

func toggle_shop():
	# Set visibility
	if visible:
		visible = false
		$"../ShopBtn".visible = true
	else:
		visible = true
		$"../ShopBtn".visible = false

	# Set process mode
	if process_mode == PROCESS_MODE_INHERIT:
		process_mode = PROCESS_MODE_DISABLED
	else:
		process_mode = PROCESS_MODE_INHERIT

func _on_tables_button_pressed():
	if Globals.money_amt >= new_table_cost and not has_all_tables:
		for table in tables:
			if table.is_bought == false:
				table.buy_table()
				Globals.money_amt -= new_table_cost
				new_table_cost *= new_table_cost_multiplier
				new_table_cost = int(new_table_cost + .5)
				tables_bought += 1
				$Stats/Chairs.text = "Chairs: " + str(root_node.max_customers)
				$"Upgrades/TablesButton/TablesButton/Price".text = "$" + str(new_table_cost)
				if tables_bought == 6:
					$"Upgrades/TablesButton/TablesButton/Price".text = "$" + str(table_upgrade_cost)
					has_all_tables = true
				return
	else:
		Globals.money_amt -= table_upgrade_cost
		table_upgrade_cost *= table_upgrade_cost_multiplier
		table_upgrade_cost = int(table_upgrade_cost + .5)
		$"Upgrades/TablesButton/TablesButton/Price".text = "$" + str(table_upgrade_cost)
		for table in tables:
			if not table.is_upgraded:
				table.upgrade_table()
				tables_upgraded += 1
				break
		$Stats/Chairs.text = "Chairs: " + str(root_node.max_customers)
	if tables_upgraded >= tables.size():
		$"Upgrades/TablesButton/TablesButton".disabled = true
	pass

func _on_rooms_button_pressed():
	if Globals.money_amt >= inn_capacity_upgrade_cost:
		Globals.money_amt -= inn_capacity_upgrade_cost
		inn_capacity_upgrade_cost *= inn_capacity_upgrade_cost_multiplier
		inn_capacity_upgrade_cost = int(inn_capacity_upgrade_cost + .5)
		$"Upgrades/RoomsButton/RoomsButton/Price".text = "$" + str(inn_capacity_upgrade_cost)
		for room in rooms:
			if not room.is_upgraded:
				room.upgrade_room()
				rooms_upgraded += 1
				break
		$Stats/InnSpace.text = "Inn Space: " + str(root_node.inn_capacity)
	if rooms_upgraded >= rooms.size():
		$"Upgrades/RoomsButton/RoomsButton".disabled = true
		
		# TODO CREATE A NEW ROOM
	pass # Replace with function body.


func _on_marketing_button_pressed():
	if Globals.money_amt >= marketing_upgrade_cost:
		Globals.money_amt -= marketing_upgrade_cost
		marketing_upgrade_cost *= marketing_upgrade_cost_multiplier
		marketing_upgrade_cost = int(marketing_upgrade_cost + .5)
		$Upgrades/MarketingButton/MarketingButton/Price.text = "$" + str(marketing_upgrade_cost)
		root_node.upgrade_marketing()
		$Stats/Marketing.text = "Marketing: " + str(root_node.marketing_level)

func _on_ambience_button_pressed():
	if Globals.money_amt >= ambience_upgrade_cost:
		Globals.money_amt -= ambience_upgrade_cost
		ambience_upgrade_cost *= ambience_upgrade_cost_multiplier
		ambience_upgrade_cost = int(ambience_upgrade_cost + .5)
		$Upgrades/AmbienceButton/AmbienceButton/Price.text = "$" + str(ambience_upgrade_cost)
		root_node.upgrade_ambience()
		$Stats/Ambience.text = "Ambience: " + str(root_node.ambience_level)
