extends Control

@onready var tables = $"../../../Tables".get_children()
@onready var rooms = $"../../../Rooms".get_children()
@onready var root_node = $"../../.."

@export var table_upgrade_cost = 100
@export var table_upgrade_cost_multiplier = 1.8

@export var inn_capacity_upgrade_cost = 500
@export var inn_capacity_upgrade_cost_multiplier = 2.0

var tables_upgraded = 0
var rooms_upgraded = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	process_mode = PROCESS_MODE_DISABLED
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_exit_shop_btn_pressed() -> void:
	#get_tree().change_scene_to_file("res://Scenes/main.tscn")
	toggle_shop()

func toggle_shop():
	# Set visibility
	if visible:
		visible = false
	else:
		visible = true
	
	# Set process mode
	if process_mode == PROCESS_MODE_INHERIT:
		process_mode = PROCESS_MODE_DISABLED
	else:
		process_mode = PROCESS_MODE_INHERIT

func _on_table_button_pressed() -> void:
	if Globals.money_amt >= table_upgrade_cost:
		Globals.money_amt -= table_upgrade_cost
		table_upgrade_cost *= table_upgrade_cost_multiplier
		table_upgrade_cost = int(table_upgrade_cost + .5)
		$"Upgrades/TablesButton/Tables/Price".text = "$" + str(table_upgrade_cost)
		for table in tables:
			if not table.is_upgraded:
				table.upgrade_table()
				tables_upgraded += 1
				break
		$Stats/Chairs.text = "Chairs: " + str(root_node.max_customers)
	if tables_upgraded >= tables.size():
		$"Upgrades/TablesButton/Tables".disabled = true
	pass


func _on_inn_capacity_pressed() -> void:
	if Globals.money_amt >= inn_capacity_upgrade_cost:
		Globals.money_amt -= inn_capacity_upgrade_cost
		inn_capacity_upgrade_cost *= inn_capacity_upgrade_cost_multiplier
		inn_capacity_upgrade_cost = int(inn_capacity_upgrade_cost + .5)
		$"Upgrades/RoomsButton/Rooms/Price".text = "$" + str(inn_capacity_upgrade_cost)
		for room in rooms:
			if not room.is_upgraded:
				room.upgrade_room()
				rooms_upgraded += 1
				break
		$Stats/BedSpace.text = "Bed Space: " + str(root_node.inn_capacity)
	if rooms_upgraded >= rooms.size():
		$"Upgrades/RoomsButton/Rooms".disabled = true
		
		# TODO CREATE A NEW ROOM
	pass # Replace with function body.
