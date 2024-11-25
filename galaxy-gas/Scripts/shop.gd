extends Control

@onready var tables = $"../Tables".get_children()

@export var table_upgrade_cost = 100
@export var table_upgrade_cost_multiplier = 1.8

@export var inn_capacity_upgrade_cost = 500
@export var inn_capacity_upgrade_cost_multiplier = 2.0

var tables_upgraded = 0

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
		$"Upgrades/Tables button/Tables/Label".text = "$" + str(table_upgrade_cost)
		for table in tables:
			if not table.is_upgraded:
				table.upgrade_table()
				tables_upgraded += 1
				break
	if tables_upgraded >= tables.size():
		$"Upgrades/Tables button/Tables".disabled = true
	pass


func _on_inn_capacity_pressed() -> void:
	if Globals.money_amt >= inn_capacity_upgrade_cost:
		Globals.money_amt -= inn_capacity_upgrade_cost
		inn_capacity_upgrade_cost *= inn_capacity_upgrade_cost_multiplier
		inn_capacity_upgrade_cost = int(inn_capacity_upgrade_cost + .5)
		$"Upgrades/Inn capacity/inn_capacity/Label".text = "$" + str(inn_capacity_upgrade_cost)
		$"..".inn_capacity += 1
		
		# TODO CREATE A NEW ROOM
	pass # Replace with function body.
