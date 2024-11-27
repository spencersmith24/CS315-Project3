extends Node2D

var is_upgraded = false

@onready var small_chairs = $Small/Chairs.get_children()
@onready var big_chairs = $Large/topChairs.get_children() + ($Large/botChairs.get_children())

var is_upgrading = false

func upgrade_table():
	is_upgrading = true
	
	$Small.process_mode = Node.PROCESS_MODE_DISABLED
	$Small.visible = false
	
	$Large.process_mode = Node.PROCESS_MODE_DISABLED
	$Large.visible = true
	is_upgraded = true
	$"../..".max_customers += 2
	
	if not is_upgraded:
		for chair in small_chairs:
			if chair.is_taken:
				chair.customer_at_chair.find_chair
	else:
		for chair in big_chairs:
			if chair.is_taken:
				chair.customer_at_chair.find_chair
	
	await get_tree().create_timer(2).timeout
	
	is_upgrading = false
func is_full():
	if not is_upgraded:
		for chair in small_chairs:
			if not chair.is_taken:
				return false
		return true
	else:
		for chair in big_chairs:
			if not chair.is_taken:
				return false
		return true
