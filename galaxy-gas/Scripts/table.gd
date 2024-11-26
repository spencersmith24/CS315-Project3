extends Node2D

var is_upgraded = false

@onready var small_chairs = $Small/Chairs.get_children()
@onready var big_chairs = $Large/topChairs.get_children() + ($Large/botChairs.get_children())

func upgrade_table():
	$Small.process_mode = Node.PROCESS_MODE_DISABLED
	$Small.visible = false
	
	$Large.process_mode = Node.PROCESS_MODE_DISABLED
	$Large.visible = true
	is_upgraded = true
	$"../..".max_customers += 2
	
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
